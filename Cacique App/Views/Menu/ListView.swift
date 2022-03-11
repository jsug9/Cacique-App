//
//  ListView.swift
//  Cacique App
//
//  Created by Augusto `Galindo Alí on 9/08/21.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var dataStore: DataStore
    
    var beers = caciqueBeers.sorted(by: <)
    
    var body: some View {
        NavigationView {
            List() {
                ForEach(beers) { beer in
                    NavigationLink(
                        destination: DetailView(beer: beer)
                            .environmentObject(dataStore),
                    label: {
                        MenuCellView(beer: beer)
                    })
                    .contextMenu {
                        if beer.stock != 0 {
                            Button(action: {
                                dataStore.addOrder.send(Order(beer: beer, quantity: 1))
                                simpleSuccess()
                            }, label: {
                                HStack {
                                    Image(systemName: "cart.fill.badge.plus")
                                    Text("Add to Cart")
                                }
                            })
                        }
                        
                        Button(action: {
                            
                        }, label: {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share")
                            }
                        })
                        
                    }
                }
            }
//            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Menu")
        }
    }
}

#if !os(watchOS)

#else

#endif

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environmentObject(DataStore())
    }
}
