//
//  CategoryDetailViewModel.swift
//  MyFoodCafe
//
//  Created by irwan on 23/02/26.
//


import Foundation

@MainActor
class CategoryDetailViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var foodDetail: CategoryFoodDetail?
    @Published var categories: [CategoryModel] = []
    @Published var loadingState: LoadingState = .idle
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    // Sama seperti HomeViewModel — pakai Repository, bukan DataSource langsung
    private let repository: FoodRepositoryProtocol
    private let foodId: String
    
    // MARK: - Init
    init(
        foodId: String,
        repository: FoodRepositoryProtocol = FoodRepository()
    ) {
        self.foodId = foodId
        self.repository = repository
    }
    
    // MARK: - Fetch Data
    func fetchData() async {
        loadingState = .loading
        errorMessage = nil
        
        do {
            async let detailResult = repository.getFoodDetailWithMapper(id: foodId)
            async let categoriesResult = repository.getCategories()
            
            let (detail, fetchedCategories) = try await (detailResult, categoriesResult)
            
            self.foodDetail = detail
            self.categories = fetchedCategories
            self.loadingState = .success
            
            print("✅ [CategoryDetail] \(detail.name), categories: \(fetchedCategories.count)")
            
        } catch {
            self.errorMessage = error.localizedDescription
            self.loadingState = .failure(error.localizedDescription)
            print("❌ [CategoryDetail] Error: \(error)")
        }
    }
    
    func refresh() async {
        await fetchData()
    }
}
