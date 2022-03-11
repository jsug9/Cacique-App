//
//  Orders.swift
//  Cacique App
//
//  Created by Augusto Galindo Alí on 9/08/21.
//

import Foundation
import Combine

class DataStore: ObservableObject {
//    orders = preOrders.map { Order(beer: $0, quantity: NSCountedSet(array: preOrders).count(for: $0)) }.uniqued()
    
    var orders = CurrentValueSubject<[Order], Never>([])
    var appError = CurrentValueSubject<ErrorType?, Never>(nil)
    var addOrder = PassthroughSubject<Order, Never>()
    var updateOrder = PassthroughSubject<Order, Never>()
    var deleteOrder = PassthroughSubject<IndexSet, Never>()
    var loadOrders = Just(FileManager.docDirURL.appendingPathComponent(fileName))
    
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        print(FileManager.docDirURL.path)
        addSubscriptions()
    }
    
    func addSubscriptions() {
        appError
            .sink { _ in
                self.objectWillChange.send()
            }
            .store(in: &subscriptions)
        
        loadOrders
            .filter { FileManager.default.fileExists(atPath: $0.path) }
            .tryMap { url in
                try Data(contentsOf: url)
            }
            .decode(type: [Order].self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue(label: "background queue"))
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    print("Loading")
                    ordersSubscription()
                case .failure(let error):
                    if error is OrderError {
                        appError.send(ErrorType(error: error as! OrderError))
                    } else {
                        appError.send(ErrorType(error: OrderError.decodingError))
                        ordersSubscription()
                    }
                }
            } receiveValue: { (orders) in
                self.objectWillChange.send()
                self.orders.value = orders
            }
            .store(in: &subscriptions)
        
        addOrder.sink { [unowned self] order in
            self.objectWillChange.send()
            if let index = orders.value.firstIndex(where: {$0.id == order.id}) {
                if order.quantity >= orders.value[index].available {
                    orders.value[index].quantity = order.beer.stock
                } else {
                    orders.value[index].quantity += order.quantity
                }
            } else {
                orders.value.append(order)
            }
        }
        .store(in: &subscriptions)
        
        updateOrder.sink { [unowned self] order in
            guard let index = orders.value.firstIndex(where: { $0.id == order.id}) else { return }
            self.objectWillChange.send()
            orders.value[index] = order
        }
        .store(in: &subscriptions)
        
        deleteOrder.sink { [unowned self] indexSet in
            self.objectWillChange.send()
            orders.value.remove(atOffsets: indexSet)
        }
        .store(in: &subscriptions)
    }
    
    func ordersSubscription() {
        orders
            .subscribe(on: DispatchQueue(label: "background queue"))
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .encode(encoder: JSONEncoder())
            .tryMap { data in
                try data.write(to: FileManager.docDirURL.appendingPathComponent(fileName))
            }
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    print("Saving Completed")
                case .failure(let error):
                    if error is OrderError {
                        appError.send(ErrorType(error: error as! OrderError))
                    } else {
                        appError.send(ErrorType(error: OrderError.encodingError))
                    }
                }
            } receiveValue: { _ in
                print("Saving file was successful")
            }
            .store(in: &subscriptions)
    }
    
    func updateView() {
        self.objectWillChange.send()
    }
    
    func deleteAllOrders() {
        self.objectWillChange.send()
        orders.value = []
    }
    
    var totalQuantity: Int {
        var total: Int = 0
        for order in orders.value {
            total += order.quantity
        }
        return total
    }
    
    var subtotalPrice: Double {
        var total: Double = 0
        for order in orders.value {
            total += order.beer.price * Double(order.quantity)
        }
        return total
    }
    
    var discount: Double {
        var quantity = 0
        
        for order in orders.value {
            quantity += order.quantity
        }
        
        switch quantity {
        case let x where x >= 24:
            return 72
        case let x where x >= 18:
            return 20
        case let x where x >= 12:
            return 12
        case let x where x >= 6:
            return 7
        case let x where x >= 4:
            return 3
        default:
            return 0
        }
    }
    
    var totalPrice: Double {
        if subtotalPrice > discount {
            return subtotalPrice - discount
        } else {
            return subtotalPrice
        }
    }
}
