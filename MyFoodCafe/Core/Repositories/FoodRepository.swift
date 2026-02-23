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
    func getFoodDetailWithMapper(id: String) async throws -> CategoryFoodDetail
}

// MARK: - Food Repository Implementation
class FoodRepository: FoodRepositoryProtocol {
    private let remoteDataSource: FoodDataSourceProtocol
    private let categoryDataSource: CategoryAlamofireDataSource
    
    init(
        remoteDataSource: FoodDataSourceProtocol = FoodRemoteDataSource(),
        categoryDataSource: CategoryAlamofireDataSource = CategoryAlamofireDataSource()
    ) {
        self.remoteDataSource = remoteDataSource
        self.categoryDataSource = categoryDataSource
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
    func getFoodDetailWithMapper(id: String) async throws -> CategoryFoodDetail {
        return try await categoryDataSource.fetchFoodDetailWithMapper(id: id)
    }
}
