//
//  CaciqueView.swift
//  Cacique App
//
//  Created by Augusto Galindo Alí on 14/08/21.
//

import SwiftUI
import AVKit

struct CaciqueView: View {
    @Environment(\.openURL) var openURL
    
    private let player = AVPlayer(url: Bundle.main.url(forResource: "Portada", withExtension: "mov")!)
    
    let instagramImage = "Instagram"
    let facebookImage = "Facebook"
    let whatsappImage = "WhatsApp"
    
    let description = "We are an Arequipa company, which puts passion to the elaboration of our craft beers, that passion makes our final product delight even the most demanding palates of our consumers. Our styles of craft beer are in constant innovation, using imported and local inputs, with which we achieve different presentations, to give our beers regional character.".localized
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ScrollView {
                    VStack(spacing: 18) {
                        VideoPlayer(player: player)
                            .disabled(true)
                            .frame(width: geo.size.width, height: geo.size.width / 2)
                            .onAppear() {
                                player.play()
                            }
                            .onDisappear() {
                                player.pause()
                            }
    //                    Image("Logo")
    //                        .resizable()
    //                        .aspectRatio(contentMode: .fit)
    //                        .frame(width: 300, height: 300, alignment: .center)
                        
                        Text(description)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        HStack {
                            Text("Find us:")
                                .font(.system(size: 25, weight: .bold))
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            Button(action: {
                                openURL(URL(string: "https://www.instagram.com/cacique_bier")!)
                            }, label: {
                                VStack {
                                    Image(instagramImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                    Text(instagramImage)
                                }
                            })
                            
                            Spacer()
                            Button(action: {
                                openURL(URL(string: "https://www.facebook.com/ElCaciqueAQP/")!)
                            }, label: {
                                VStack {
                                    Image(facebookImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                    Text(facebookImage)
                                }
                            })
                            
                            Spacer()
                            Button(action: {
                                openURL(URL(string: "https://wa.me/51958304441")!)
                            }, label: {
                                VStack {
                                    Image(whatsappImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                    Text(whatsappImage)
                                }
                            })
                            .contextMenu {
                                HStack {
                                    Button(action: {
                                        openURL(URL(string: "tel://+51958304441")!)
                                    }, label: {
                                        Text("+51 958 304 441")
                                        Image(systemName: "phone.fill")
                                    })
                                }
                            }
                        }
                        .foregroundColor(Color(UIColor.label))
                        .padding(.horizontal)
                        Spacer()
                        
                    }
                    .navigationTitle("Who are we?")
                }
                .fixFlickering()
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct CaciqueView_Previews: PreviewProvider {
    static var previews: some View {
        CaciqueView()
    }
}
