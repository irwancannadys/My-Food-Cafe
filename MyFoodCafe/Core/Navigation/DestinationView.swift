//
//  DestinationView.swift
//  MyFoodCafe
//
//  Created by irwan on 29/12/25.
//

import SwiftUI

struct DestinationView {
    @ViewBuilder
    static func destinationView(for route: Route) -> some View {
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
            CartView()
        }
    }
}
