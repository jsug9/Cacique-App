//
//  Animations.swift
//  Cacique App
//
//  Created by Augusto Galindo Alí on 15/08/21.
//

import SwiftUI
import AVKit

func simpleSuccess() {
#if os(iOS) && !targetEnvironment(macCatalyst)
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
#endif
}

#if os(iOS)
struct NavigationBarModifier: ViewModifier {

    var backgroundColor: UIColor?
    var titleColor: UIColor?

    init(backgroundColor: UIColor?, titleColor: UIColor?) {
        self.backgroundColor = backgroundColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = backgroundColor
        coloredAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .white]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }

    func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .ignoresSafeArea(.all, edges: .top)
                    Spacer()
                }
            }
        }
    }
}

extension View {
    func navigationBarColor(backgroundColor: UIColor?, titleColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor, titleColor: titleColor))
    }
}
#else
extension View {
    func navigationBarColor(backgroundColor: UIColor?, titleColor: UIColor?) -> some View {
        self
    }
}
#endif

extension ScrollView {

    public func fixFlickering() -> some View {

        return self.fixFlickering { (scrollView) in

            return scrollView
        }
    }

    public func fixFlickering<T: View>(@ViewBuilder configurator: @escaping (ScrollView<AnyView>) -> T) -> some View {

        GeometryReader { geometryWithSafeArea in
            GeometryReader { geometry in
                configurator(
                ScrollView<AnyView>(self.axes, showsIndicators: self.showsIndicators) {
                    AnyView(
                    VStack {
                        self.content
                    }
                    .padding(.top, geometryWithSafeArea.safeAreaInsets.top)
                    .padding(.bottom, geometryWithSafeArea.safeAreaInsets.bottom)
                    .padding(.leading, geometryWithSafeArea.safeAreaInsets.leading)
                    .padding(.trailing, geometryWithSafeArea.safeAreaInsets.trailing)
                    )
                }
                )
            }
            .ignoresSafeArea()
        }
    }
}
