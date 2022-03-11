//
//  Model.swift
//  Cacique App
//
//  Created by Augusto Galindo Alí on 9/08/21.
//

import Foundation

struct Beer {
    var id: String
    var ingredients: String = "Agua, malta, lúpulo, levadura."
    var description: String
    
    var ibu: Int
    var abv: Double
    
    var stock: Int = 50
    var price: Double = 12
}

extension Beer: Identifiable, Equatable, Codable, Hashable { }

extension Beer: Comparable {
    static func < (lhs: Beer, rhs: Beer) -> Bool {
        lhs.id < rhs.id
    }
}
