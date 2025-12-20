//
//  RestaurantModel.swift
//  MyFoodCafe
//
//  Created by irwan on 20/12/25.
//

import Foundation

// MARK: - Restaurant Model
struct RestaurantModel: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let cuisine: String
    let imageUrl: String
    let rating: Double
    let deliveryTime: String
    let distance: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case cuisine
        case imageUrl = "image_url"
        case rating
        case deliveryTime = "delivery_time"
        case distance
    }
}

// MARK: - Mock Data
extension RestaurantModel {
    static let mockList: [RestaurantModel] = [
        RestaurantModel(
            id: "rest1",
            name: "Warung Sederhana",
            cuisine: "Indonesian",
            imageUrl: "https://picsum.photos/400/300?random=5",
            rating: 4.5,
            deliveryTime: "25-35 min",
            distance: "1.2 km"
        ),
        RestaurantModel(
            id: "rest2",
            name: "Pizza House",
            cuisine: "Italian",
            imageUrl: "https://picsum.photos/400/300?random=6",
            rating: 4.8,
            deliveryTime: "30-40 min",
            distance: "2.5 km"
        ),
        RestaurantModel(
            id: "rest3",
            name: "Sushi Master",
            cuisine: "Japanese",
            imageUrl: "https://picsum.photos/400/300?random=7",
            rating: 4.6,
            deliveryTime: "35-45 min",
            distance: "3.0 km"
        )
    ]
}
