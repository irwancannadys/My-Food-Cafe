//
//  FoodRepository.swift
//  MyFoodCafe
//
//  Created by irwan on 20/12/25.
//

import Foundation

// MARK: - Repository Protocol
protocol FoodRepositoryProtocol {
    func getFoods() async throws -> [FoodModel]
    func getFoodDetail(id: String) async throws -> FoodDetailModel
    func getCategories() async throws -> [CategoryModel]
    func getBanners() async throws -> [BannerModel]
}

// MARK: - Food Repository Implementation
class FoodRepository: FoodRepositoryProtocol {
    private let remoteDataSource: FoodDataSourceProtocol
    
    init(remoteDataSource: FoodDataSourceProtocol = FoodRemoteDataSource()) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getFoods() async throws -> [FoodModel] {
        return try await remoteDataSource.fetchFoods()
    }
    
    func getFoodDetail(id: String) async throws -> FoodDetailModel {
        return try await remoteDataSource.fetchFoodDetail(id: id)
    }
    
    func getCategories() async throws -> [CategoryModel] {
        return try await remoteDataSource.fetchCategories()
    }
    
    func getBanners() async throws -> [BannerModel] {
        return try await remoteDataSource.fetchBanners()
    }
}
