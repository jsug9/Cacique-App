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
#if os(visionOS)
        VisionMainView()
            .environmentObject(dataStore)
#else
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
        .tabViewStyle(.sidebarAdaptable)
        .environmentObject(dataStore)
#endif
    }
}

#if os(visionOS)
private enum SidebarItem: Int, CaseIterable, Identifiable {
    case cacique, menu, cart

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .cacique: return "Cacique"
        case .menu:    return "Menu"
        case .cart:    return "Cart"
        }
    }

    var systemImage: String {
        switch self {
        case .cacique: return "house"
        case .menu:    return "list.dash"
        case .cart:    return "cart.fill"
        }
    }
}

private struct VisionMainView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var selection: SidebarItem? = .cacique

    var body: some View {
        NavigationSplitView {
            List(SidebarItem.allCases, selection: $selection) { item in
                Label(item.title, systemImage: item.systemImage)
                    .tag(item)
            }
            .navigationTitle("Cacique")
        } detail: {
            switch selection {
            case .cacique, .none:
                CaciqueView()
            case .menu:
                ListView()
            case .cart:
                OrderView()
            }
        }
    }
}
#endif

#Preview {
    MainView()
        .environmentObject(DataStore())
}
