//
//  APIResponse.swift
//  MyFoodCafe
//
//  Created by irwan on 20/12/25.
//

import Foundation

// MARK: - Generic API Response
struct APIResponse<T: Decodable>: Decodable {
    let status: String
    let message: String
    let data: T?
}

// MARK: - Foods Response
struct FoodsData: Decodable {
    let foods: [FoodModel]
}

// MARK: - Food Detail Response
struct FoodDetailData: Decodable {
    let food: FoodDetailModel
}

// MARK: - Categories Response
struct CategoriesData: Decodable {
    let categories: [CategoryModel]
}

// MARK: - Banners Response
struct BannersData: Decodable {
    let banners: [BannerModel]
}
