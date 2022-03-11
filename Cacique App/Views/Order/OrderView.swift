//
//  OrderView.swift
//  Cacique App
//
//  Created by Augusto Galindo Alí on 9/08/21.
//

import SwiftUI

struct OrderView: View {
    @EnvironmentObject var dataStore: DataStore
    
    @State private var editMode = EditMode.inactive
    @State private var confirmationAlert = false
    @State private var finalAlert = false
    
    var buttonisDisabled: Bool {
        dataStore.totalQuantity == 0 ? true : false
    }
    
    private var editButton: some View {
        return Group {
            switch editMode {
            case .inactive:
                if dataStore.orders.value.count == 0 {
                    EmptyView()
                } else {
                    EditButton()
                }
            case .active:
                EditButton()
            default:
                EmptyView()
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List() {
                    ForEach(dataStore.orders.value) { order in
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
                    .onDelete(perform: dataStore.deleteOrder.send)
                }
//                .listStyle(InsetGroupedListStyle())
                VStack(spacing: 8) {
                    HStack {
                        Text("Subtotal:")
                        Spacer()
                        //Correct Total
                        Text(dataStore.subtotalPrice.currencyPEN())
                            .frame(width: 100, alignment: .leading)
                    }
                    
                    HStack {
                        Text("Discount:")
                        Spacer()
                        //Correct Total
                        Text(dataStore.discount.currencyPEN())
                            .frame(width: 100, alignment: .leading)
                    }
                    
                    HStack {
                        Text("Total:")
                            .bold()
                        Spacer()
                        //Correct Total
                        Text(dataStore.totalPrice.currencyPEN())
                            .bold()
                            .frame(width: 100, alignment: .leading)
                    }
                    
                    Button(action: {
                        confirmationAlert.toggle()
                    }, label: {
                        HStack {
                            Spacer()
                            Image(systemName: "creditcard.fill")
                            Text("Finish Order")
                            Spacer()
                        }
                    })
                    .padding(12)
                    .foregroundColor(.white)
                    .background(Color.blue.opacity(!buttonisDisabled ? 1 : 0.5))
                    .cornerRadius(8.0)
                    .disabled(buttonisDisabled)
                    .alert(isPresented: $confirmationAlert, content: {
                        Alert(
                            title: Text("Confirmar Compra"),
                            message: Text("¿Comprar \(dataStore.totalQuantity) cervezas por \(dataStore.totalPrice.currencyPEN())?"),
                            primaryButton: .default(Text("Pagar"), action: {
                                //Add Final Action
                                dataStore.deleteAllOrders()
                                finalAlert.toggle()
                            }),
                            secondaryButton: .cancel())
                    })
//                    .alert(isPresented: $finalAlert, content: {
//                        Alert(
//                            title: Text("Thanks for your order!"),
//                            message: Text("We are preparing your order."),
//                            dismissButton: .cancel()
//                        )
//                    })
                }
                .padding(.vertical, 9)
                .padding([.horizontal, .bottom])
                .edgesIgnoringSafeArea(.bottom)
                .background(Color(UIColor.systemBackground))
                
                .navigationTitle("Cart")
                .navigationBarItems(leading: EditButton())
//                .environment(\.editMode, $editMode)
//                .onChange(of: dataStore.orders.value) { newValue in
//                    if editMode == .active && dataStore.orders.value.count == 0 {
//                        editMode = .inactive
//                    }
//                }
                .onAppear(perform: {
                    dataStore.updateView()
                })
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
            .environmentObject(DataStore())
    }
}
