//
//  OrderCellView.swift
//  Cacique App
//
//  Created by Augusto Galindo Alí on 10/08/21.
//

import SwiftUI

struct OrderCellView: View {
    @EnvironmentObject var dataStore: DataStore
    @Binding var order: Order
    
    var body: some View {
        HStack(spacing: 10) {
            Image(order.id)
                .resizable()
                .scaledToFit()
                .frame(width: 65,height: 60)
            
            Text(order.id)
            Spacer()
            
            Text(String(order.quantity))
                .foregroundColor(.blue)
            
            VStack (spacing: 10){
                Button(action: {
                    var order1 = order
                    order1.quantity += 1
                    dataStore.updateOrder.send(order1)
                }, label: {
                    Image(systemName: "chevron.up")
                })
                .disabled(order.available == 0 ? true : false)
                Button(action: {
                    var order1 = order
                    order1.quantity -= 1
                    dataStore.updateOrder.send(order1)
                }, label: {
                    Image(systemName: "chevron.down")
                })
                .disabled(order.quantity == 1 ? true : false)
            }
            .foregroundColor(.blue)
            .buttonStyle(PlainButtonStyle())
            
            Text(order.price.currencyPEN())
                .frame(width: 80, alignment: .leading)
        }
    }
    
}

#Preview {
    @Previewable @State var order = Order(beer: caciqueBeers[0], quantity: 1)
    List {
        OrderCellView(order: $order)
    }
}


