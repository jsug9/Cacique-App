//
//  MainView.swift
//  Cacique App
//
//  Created by Augusto Galindo Alí on 9/08/21.
//

import SwiftUI

struct MainView: View {
    var dataStore = DataStore()
    @State private var selection = 1
    
    var body: some View {
        TabView(selection: $selection) {
            CaciqueView()
                .tabItem {
                    Image("TabLogo")
                    Text("Cacique")
                }
                .tag(0)
            
            ListView()
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }
                .tag(1)

            OrderView()
                .tabItem {
                    Label("Cart", systemImage: "cart.fill")
                }
                .tag(2)
        }
        .environmentObject(dataStore)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(DataStore())
    }
}
