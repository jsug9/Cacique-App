//
//  NumberPicker.swift
//  Cacique App
//
//  Created by Augusto Galindo Alí on 13/08/21.
//

import SwiftUI

struct NumberPicker: View {
    @Binding var selection: Int
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                self.isShowing = false
            }) {
                HStack {
                    Spacer()
                    Text("Close")
                        .padding(.horizontal, 16)
                }
            }
            Picker(selection: $selection, label: Text("")) {
                ForEach((1..<50), id: \.self) {
                    Text("\($0)")
                        .tag($0)
                }
            }
            .frame(width: 200)
            .labelsHidden()
        }
    }
}

struct NumberPicker_Previews: PreviewProvider {
    static var previews: some View {
        NumberPicker(selection: .constant(2000), isShowing: .constant(true))
    }
}
