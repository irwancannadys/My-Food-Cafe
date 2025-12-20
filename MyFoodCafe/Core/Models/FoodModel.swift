//
//  FoodModel.swift
//  MyFoodCafe
//
//  Created by irwan on 20/12/25.
//

import Foundation

// MARK: - Food Model (for list)
struct FoodModel: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let imageUrl: String
    let category: String
    let rating: Double
    let totalReviews: Int
    let restaurantId: String
    let restaurantName: String
    let isFavorite: Bool
    let isAvailable: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case price
        case imageUrl = "image_url"
        case category
        case rating
        case totalReviews = "total_reviews"
        case restaurantId = "restaurant_id"
        case restaurantName = "restaurant_name"
        case isFavorite = "is_favorite"
        case isAvailable = "is_available"
    }
}

// MARK: - Food Detail Model (for detail screen)
struct FoodDetailModel: Codable, Hashable {
    let id: String
    let name: String
    let description: String
    let longDescription: String
    let price: Double
    let imageUrl: String
    let images: [String]
    let category: String
    let rating: Double
    let totalReviews: Int
    let restaurantId: String
    let restaurantName: String
    let restaurantAddress: String
    let restaurantRating: Double
    let deliveryTime: String
    let deliveryFee: Double
    let isFavorite: Bool
    let isAvailable: Bool
    let ingredients: [String]
    let nutrition: Nutrition
    
    struct Nutrition: Codable, Hashable {
        let calories: Int
        let protein: String
        let carbs: String
        let fat: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, price, category, rating, ingredients, nutrition
        case longDescription = "long_description"
        case imageUrl = "image_url"
        case images
        case totalReviews = "total_reviews"
        case restaurantId = "restaurant_id"
        case restaurantName = "restaurant_name"
        case restaurantAddress = "restaurant_address"
        case restaurantRating = "restaurant_rating"
        case deliveryTime = "delivery_time"
        case deliveryFee = "delivery_fee"
        case isFavorite = "is_favorite"
        case isAvailable = "is_available"
    }
}

// MARK: - Mock Data (keep for preview)
extension FoodModel {
    static let mock = FoodModel(
        id: "food_001",
        name: "Nasi Goreng Special",
        description: "Nasi goreng dengan telur, ayam, dan sayuran segar",
        price: 25000,
        imageUrl: "https://picsum.photos/400/300?random=1",
        category: "Indonesian",
        rating: 4.5,
        totalReviews: 150,
        restaurantId: "rest_001",
        restaurantName: "Warung Sederhana",
        isFavorite: false,
        isAvailable: true
    )
    
    static let mockList: [FoodModel] = [mock]
}
