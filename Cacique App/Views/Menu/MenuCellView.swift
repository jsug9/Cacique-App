//
//  CellView.swift
//  Cacique App
//
//  Created by Augusto Galindo Alí on 9/08/21.
//

import SwiftUI

struct MenuCellView: View {
    @EnvironmentObject var dataStore: DataStore
    
    @State var beer: Beer
    
    var body: some View {
        HStack {
            #if !os(watchOS)
            Image(beer.id)
                .resizable()
                .scaledToFit()
                .frame(width: 65,height: 60)
            #endif
            Text(beer.id)
            Spacer()
        }
        .foregroundColor(beer.stock > 0 ? Color(UIColor.label) : Color(UIColor.secondaryLabel))
    }
}

struct MenuCellView_Previews: PreviewProvider {
    @State private var selection = 1
    
    static var previews: some View {
        MenuCellView(beer: caciqueBeers[3])
    }
}
