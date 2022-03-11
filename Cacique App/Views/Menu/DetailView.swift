//
//  DetailView.swift
//  Cacique App
//
//  Created by Augusto Galindo Alí on 9/08/21.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var dataStore: DataStore
    @State var isTapped = false
    
    @State var beer: Beer
    @State private var quantityStepper = 1
    
    @State private var animationAmount: CGFloat = 0
    
    var isAvailable: Bool {
        beer.stock == 0 ? false : true
    }
    
    var buttonIsAvailable: Bool {
        if beer.stock == 0 || quantityStepper == 0 {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            Group() {
                if geometry.size.height > geometry.size.width {
                    verticalView()
                } else {
                    horizontalView()
                }
            }
        }
//       Bar Items
        .navigationTitle(beer.id)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarColor(backgroundColor: .systemBackground, titleColor: .label)
        .navigationBarItems(trailing: Button(action: {
            //Share Beer
            
        }, label: {
            Image(systemName: "square.and.arrow.up")
                .imageScale(.medium)
        }))
    }
//    Functionality
    func addOrder() {
        dataStore.addOrder.send(Order(beer: beer, quantity: quantityStepper))
    }
    
//    Animations
    func isAnimated() {
        isTapped = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isTapped = false
        }
    }
    
//    Views
    func verticalView() -> some View {
        VStack {
            ScrollView {
                beerImage()
                beerInformation()
                    .padding(.horizontal)
            }
            checkOut()
        }
    }
    
    func horizontalView() -> some View {
        VStack {
            HStack() {
                VStack {
                    beerImage()
                    Spacer()
                }
                
                VStack {
                    ScrollView {
                        beerInformation()
                            .padding([.horizontal, .top])
                    }
                    if UIDevice.current.localizedModel == "iPhone" {
                         checkOut()
                    }
                }
            }
            if UIDevice.current.localizedModel != "iPhone" {
                 checkOut()
            }
        }
    }
    
//    SubViews
    func beerImage() -> some View {
        Image(beer.id)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(.bottom, 5)
    }
    
    func beerInformation() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack() {
                Image("Hop")
                Text("IBU:")
                    .bold()
                Text(String(beer.ibu))
                Spacer()
                Image(systemName: "aqi.medium")
                    .imageScale(.small)
                Text("ABV:")
                    .bold()
                Text("\(beer.abv.twoDecimals())%")
            }
            .font(.system(size: 18))
            Text("Description:")
                .font(.title2)
                .bold()
            Text(beer.description)
        }
    }
    
    func checkOut() -> some View {
        VStack {
            Stepper(value: $quantityStepper, in: 0...beer.stock) {
                HStack {
                    Text("Amount:")
                    Spacer()
                    Text("\(quantityStepper)")
                        .foregroundColor(isAvailable ? Color.blue : Color(UIColor.secondaryLabel))
                }
            }
            .disabled(!isAvailable)
            
            Button(action: {
                addOrder()
                simpleSuccess()
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    isAnimated()
                }
            }, label: {
                HStack {
                    Spacer()
                    if isAvailable {
                        Image(systemName: "cart.fill.badge.plus")
                        Text("Add to Cart")
                    } else {
                        Image(systemName: "slash.circle")
                        Text("Not Available")
                    }
                    Spacer()
                }
            })
            .padding(12)
            .foregroundColor(.white)
            .background(Color.blue.opacity(!buttonIsAvailable ? 1 : 0.5))
            .cornerRadius(8.0)
            .scaleEffect(isTapped ? 1.2 : 1)
            .disabled(buttonIsAvailable)
        }
        .background(Color(UIColor.systemBackground.withAlphaComponent(0.5)))
        .padding([.horizontal, .bottom])
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        TabView() {
            NavigationView {
                DetailView(beer: caciqueBeers[3])
                    .environmentObject(DataStore())
            }
            .tabItem {
                Label("Menu", systemImage: "list.dash")
            }
        }
//        .landscape()
    }
}

struct LandscapeModifier: ViewModifier {
    let height = UIScreen.main.bounds.width // 1
    let width = UIScreen.main.bounds.height // 2
    
    func body(content: Content) -> some View {
        content
            .previewLayout(.fixed(width: width, height: height)) // 3
            .environment(\.horizontalSizeClass, .compact)
            .environment(\.verticalSizeClass, .compact)
    }
}

extension View {
    func landscape() -> some View {
        modifier(LandscapeModifier())
    }
}
