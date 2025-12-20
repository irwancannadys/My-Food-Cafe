//
//  FoodDataSource.swift
//  MyFoodCafe
//
//  Created by irwan on 20/12/25.
//

import Foundation

// MARK: - Food Data Source Protocol
protocol FoodDataSourceProtocol {
    func fetchFoods() async throws -> [FoodModel]
    func fetchFoodDetail(id: String) async throws -> FoodDetailModel
    func fetchCategories() async throws -> [CategoryModel]
    func fetchBanners() async throws -> [BannerModel]
}

// MARK: - Remote Data Source (API)
class FoodRemoteDataSource: FoodDataSourceProtocol {
    private let apiService = APIService.shared
    
    func fetchFoods() async throws -> [FoodModel] {
        let response: APIResponse<FoodsData> = try await apiService.request(
            endpoint: .foods
        )
        
        guard let foods = response.data?.foods else {
            throw APIError.invalidResponse
        }
        
        return foods
    }
    
    func fetchFoodDetail(id: String) async throws -> FoodDetailModel {
        let response: APIResponse<FoodDetailData> = try await apiService.request(
            endpoint: .foodDetail(id: id)
        )
        
        guard let food = response.data?.food else {
            throw APIError.invalidResponse
        }
        
        return food
    }
    
    func fetchCategories() async throws -> [CategoryModel] {
        let response: APIResponse<CategoriesData> = try await apiService.request(
            endpoint: .categories
        )
        
        guard let categories = response.data?.categories else {
            throw APIError.invalidResponse
        }
        
        return categories
    }
    
    func fetchBanners() async throws -> [BannerModel] {
        let response: APIResponse<BannersData> = try await apiService.request(
            endpoint: .banners
        )
        
        guard let banners = response.data?.banners else {
            throw APIError.invalidResponse
        }
        
        return banners
    }
}
