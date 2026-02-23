//
//  MyFoodCafeApp.swift
//  MyFoodCafe
//
//  Created by irwan on 19/12/25.
//

import SwiftUI

//@main
//struct MyFoodCafeApp: App {
//
//    @StateObject private var router = Router()
//
//    let persistenceController = PersistenceController.shared
//    @StateObject private var cartManager: CartViewModel
//
//    init() {
//        let context = PersistenceController.shared.container.viewContext
//        _cartManager = StateObject(wrappedValue: CartViewModel(context: context))
//    }
//
//    var body: some Scene {
//        WindowGroup {
//            NavigationStack(path: $router.path) {
//                ContentView()
//                    .navigationDestination(for: Route.self) { route in
//                        DestinationView.destinationView(for: route)
//                    }
//            }
//            .environmentObject(router)
//            .environment(
//                \.managedObjectContext,
//                 persistenceController.container.viewContext
//            )
//            .environmentObject(cartManager)
//        }
//    }
//}

@main
struct MyFoodCafeApp: App {
    @StateObject private var router = Router()
    @StateObject private var cartManager = CartViewModel()
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                ContentView()
                    .navigationDestination(for: Route.self) { route in
                        DestinationView.destinationView(for: route)
                    }
            }
            .environmentObject(router)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(cartManager)
        }
    }
}
