//
//  ListView.swift
//  Cacique App
//
//  Created by Augusto Galindo Alí on 9/08/21.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var dataStore: DataStore

    var beers = caciqueBeers.sorted(by: <)

    var body: some View {
        NavigationStack {
            List {
                ForEach(beers) { beer in
                    NavigationLink(destination: DetailView(beer: beer).environmentObject(dataStore)) {
                        MenuCellView(beer: beer)
                    }
                    .contextMenu {
                        if beer.stock != 0 {
                            Button(action: {
                                dataStore.addOrder.send(Order(beer: beer, quantity: 1))
                                simpleSuccess()
                            }, label: {
                                Label("Add to Cart", systemImage: "cart.fill.badge.plus")
                            })
                        }

                        Button(action: {}, label: {
                            Label("Share", systemImage: "square.and.arrow.up")
                        })
                    }
                }
            }
            .navigationTitle("Menu")
        }
    }
}

#Preview {
    ListView()
        .environmentObject(DataStore())
}
