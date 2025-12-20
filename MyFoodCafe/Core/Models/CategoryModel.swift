//
//  CategoryModel.swift
//  MyFoodCafe
//
//  Created by irwan on 20/12/25.
//

import Foundation

struct CategoryModel: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let icon: String
    let totalItems: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case icon
        case totalItems = "total_items"
    }
}

// MARK: - Mock Data
extension CategoryModel {
    static let mockList: [CategoryModel] = [
        CategoryModel(id: "cat_001", name: "Popular", icon: "flame.fill", totalItems: 45),
        CategoryModel(id: "cat_002", name: "Main", icon: "fork.knife", totalItems: 32),
        CategoryModel(id: "cat_003", name: "Drinks", icon: "cup.and.saucer.fill", totalItems: 28),
        CategoryModel(id: "cat_004", name: "Dessert", icon: "birthday.cake.fill", totalItems: 19),
    ]
}
