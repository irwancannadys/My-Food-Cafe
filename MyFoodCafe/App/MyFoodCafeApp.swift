//
//  MyFoodCafeApp.swift
//  MyFoodCafe
//
//  Created by irwan on 19/12/25.
//

import SwiftUI

@main
struct MyFoodCafeApp: App {
    
    @StateObject private var router = Router()
    
    var body: some Scene {
          WindowGroup {
              NavigationStack(path: $router.path) {
                  ContentView()
                      .navigationDestination(for: Route.self) { route in
                          destinationView(for: route)
                      }
              }
              .environmentObject(router)
          }
      }
    
    @ViewBuilder
        func destinationView(for route: Route) -> some View {
            switch route {
            case .home:
                Text("Home")
            case .search:
                Text("Search")
            case .order:
                Text("Order")
            case .profile:
                Text("Profile")
            case .foodDetail(let food):
                FoodDetailView(food: food)
            case .restaurantDetail(let restaurant):
                Text("Restaurant: \(restaurant.name)")
            case .cart:
                Text("Cart")
            }
        }
}
