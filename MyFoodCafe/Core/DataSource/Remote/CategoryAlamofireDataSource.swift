//
//  CategoryAlamofireDataSource.swift
//  MyFoodCafe
//
//  Created by irwan on 23/02/26.
//

import Foundation

// Data source baru khusus pakai Alamofire
// Tidak mengubah FoodRemoteDataSource yang sudah ada
class CategoryAlamofireDataSource {
    private let afService = AlamofireService.shared
    
    func fetchFoodDetail(id: String) async throws -> FoodDetailModel {
        let response: APIResponse<FoodDetailData> = try await afService.request(
            endpoint: .foodDetail(id: id)
        )
        
        guard let food = response.data?.food else {
            throw APIError.invalidResponse
        }
        
        return food
    }
    
    func fetchFoodDetailWithMapper(id: String) async throws -> CategoryFoodDetail {
           let response: APIResponse<FoodDetailData> = try await afService.request(
               endpoint: .foodDetail(id: id)
           )
           
           guard let food = response.data?.food else {
               throw APIError.invalidResponse
           }
           
           // Mapper dipanggil di sini — raw response langsung di-convert
           return food.toCategoryFoodDetail()
       }
    
    func fetchCategories() async throws -> [CategoryModel] {
        let response: APIResponse<CategoriesData> = try await afService.request(
            endpoint: .categories
        )
        
        guard let categories = response.data?.categories else {
            throw APIError.invalidResponse
        }
        
        return categories
    }
}
