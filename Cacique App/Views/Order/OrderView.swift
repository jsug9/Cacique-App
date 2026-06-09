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

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(dataStore.orders.value) { order in
                        HStack(spacing: 10) {
                            Image(order.id)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 65, height: 60)

                            Text(order.id)
                            Spacer()

                            Text(String(order.quantity))
                                .foregroundColor(.blue)

                            VStack(spacing: 10) {
                                Button(action: {
                                    var order1 = order
                                    order1.quantity += 1
                                    dataStore.updateOrder.send(order1)
                                }, label: {
                                    Image(systemName: "chevron.up")
                                })
                                .disabled(order.available == 0)
                                Button(action: {
                                    var order1 = order
                                    order1.quantity -= 1
                                    dataStore.updateOrder.send(order1)
                                }, label: {
                                    Image(systemName: "chevron.down")
                                })
                                .disabled(order.quantity == 1)
                            }
                            .foregroundColor(.blue)
                            .buttonStyle(PlainButtonStyle())

                            Text(order.price.currencyPEN())
                                .frame(width: 80, alignment: .leading)
                        }
                    }
                    .onDelete(perform: dataStore.deleteOrder.send)
                }

                VStack(spacing: 8) {
                    HStack {
                        Text("Subtotal:")
                        Spacer()
                        Text(dataStore.subtotalPrice.currencyPEN())
                            .frame(width: 100, alignment: .leading)
                    }

                    HStack {
                        Text("Discount:")
                        Spacer()
                        Text(dataStore.discount.currencyPEN())
                            .frame(width: 100, alignment: .leading)
                    }

                    HStack {
                        Text("Total:")
                            .bold()
                        Spacer()
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
                    .clipShape(.rect(cornerRadius: 8))
                    .disabled(buttonisDisabled)
                    .alert("Confirmar Compra", isPresented: $confirmationAlert) {
                        Button("Pagar") {
                            dataStore.deleteAllOrders()
                            finalAlert.toggle()
                        }
                        Button("Cancelar", role: .cancel) {}
                    } message: {
                        Text("¿Comprar \(dataStore.totalQuantity) cervezas por \(dataStore.totalPrice.currencyPEN())?")
                    }
                }
                .padding(.vertical, 9)
                .padding([.horizontal, .bottom])
                .ignoresSafeArea(.container, edges: .bottom)
                .background(Color(UIColor.systemBackground))
            }
            .navigationTitle("Cart")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .onAppear {
                dataStore.updateView()
            }
        }
    }
}

#Preview {
    OrderView()
        .environmentObject(DataStore())
}
