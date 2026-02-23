//
//  CategoryFoodDetail.swift
//  MyFoodCafe
//
//  Created by irwan on 23/02/26.
//

import Foundation

// MARK: - Model (hanya field yang dibutuhkan di CategoryDetailView)
struct CategoryFoodDetail {
    let id: String
    let name: String
    let price: Double
    let imageUrl: String
    let longDescription: String
    let ingredients: [String]
    let nutrition: Nutrition
    let restaurantName: String
    let deliveryTime: String
    
    struct Nutrition {
        let calories: Int
        let protein: String
        let carbs: String
        let fat: String
    }
}

// MARK: - Mapper Extension
// Mapper ditaruh di extension FoodDetailModel supaya
// FoodDetailModel yang "tahu cara convert dirinya sendiri"
extension FoodDetailModel {
    func toCategoryFoodDetail() -> CategoryFoodDetail {
        return CategoryFoodDetail(
            id: self.id,
            name: self.name,
            price: self.price,
            imageUrl: self.imageUrl,
            longDescription: self.longDescription,
            ingredients: self.ingredients,
            nutrition: CategoryFoodDetail.Nutrition(
                calories: self.nutrition.calories,
                protein: self.nutrition.protein,
                carbs: self.nutrition.carbs,
                fat: self.nutrition.fat
            ),
            restaurantName: self.restaurantName,
            deliveryTime: self.deliveryTime
        )
    }
}
