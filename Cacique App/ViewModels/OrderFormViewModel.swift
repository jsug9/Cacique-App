//
//  BeerFormViewModel.swift
//  Cacique App
//
//  Created by Augusto Galindo Alí on 9/08/21.
//

import Foundation

class OrderFormViewModel: ObservableObject {
    @Published var beer: Beer = Beer(id: "", ingredients: "", description: "", ibu: 0, abv: 0)
    @Published var quantity: Int = 1
    
    var id: String = ""
    
    init() {}
    
    init(_ currentOrder: Order) {
        self.beer = currentOrder.beer
        self.quantity = currentOrder.quantity
        id = currentOrder.id
    }
}
