//
//  Router.swift
//  MyFoodCafe
//
//  Created by irwan on 19/12/25.
//

import SwiftUI

// MARK: - Routes
enum Route: Hashable {
    case home
    case search
    case order
    case profile
    case foodDetail(FoodModel)
    case restaurantDetail(RestaurantModel)
    case cart
    case categoryDetail(id: String)
}

// MARK: - Router
class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate(to route: Route) {
        path.append(route)
    }
    
    func navigateBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func navigateToRoot() {
        path.removeLast(path.count)
    }
    
    func replace(with route: Route) {
        if !path.isEmpty {
            path.removeLast()
        }
        path.append(route)
    }
}
