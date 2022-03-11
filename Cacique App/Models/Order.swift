//
//  Order.swift
//  Cacique App
//
//  Created by Augusto Galindo Alí on 10/08/21.
//

import Foundation

struct Order {
    var id: String
    var beer: Beer
    var quantity: Int
    
    init(beer: Beer, quantity: Int) {
        self.id = beer.id
        self.beer = beer
        self.quantity = quantity
    }
    
    var price: Double {
        beer.price * Double(quantity)
    }
    
    var available: Int {
        beer.stock - quantity
    }
}

extension Order: Identifiable, Equatable, Codable, Hashable { }
