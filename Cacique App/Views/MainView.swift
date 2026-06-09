//
//  MainView.swift
//  Cacique App
//
//  Created by Augusto Galindo Alí on 9/08/21.
//

import SwiftUI

struct MainView: View {
    var dataStore = DataStore()

    var body: some View {
        TabView {
            Tab("Cacique", image: "TabLogo") {
                CaciqueView()
            }
            Tab("Menu", systemImage: "list.dash") {
                ListView()
            }
            Tab("Cart", systemImage: "cart.fill") {
                OrderView()
            }
        }
        .environmentObject(dataStore)
    }
}

#Preview {
    MainView()
        .environmentObject(DataStore())
}
