//
//  HomeViewModel.swift
//  MyFoodCafe
//
//  Created by irwan on 20/12/25.
//

import Foundation

// MARK: - Home ViewModel
@MainActor
class HomeViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var foods: [FoodModel] = []
    @Published var categories: [CategoryModel] = []
    @Published var banners: [BannerModel] = []
    @Published var loadingState: LoadingState = .idle
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    private let repository: FoodRepositoryProtocol
    
    // MARK: - Init
    init(repository: FoodRepositoryProtocol = FoodRepository()) {
        self.repository = repository
    }
    
    // MARK: - Fetch All Home Data
    func fetchHomeData() async {
        loadingState = .loading
        
        do {
            // Fetch semua data parallel dengan async let
            async let foodsResult = repository.getFoods()
            async let categoriesResult = repository.getCategories()
            async let bannersResult = repository.getBanners()
            
            // Await semua results
            let (fetchedFoods, fetchedCategories, fetchedBanners) = try await (
                foodsResult,
                categoriesResult,
                bannersResult
            )
            
            // Update state
            self.foods = fetchedFoods
            self.categories = fetchedCategories
            self.banners = fetchedBanners
            self.loadingState = .success
            
        } catch {
            self.errorMessage = error.localizedDescription
            self.loadingState = .failure(error.localizedDescription)
            print("Error fetching home data: \(error)")
        }
    }
    
    // MARK: - Fetch Foods Only
    func fetchFoods() async {
        do {
            let fetchedFoods = try await repository.getFoods()
            self.foods = fetchedFoods
        } catch {
            self.errorMessage = error.localizedDescription
            print("Error fetching foods: \(error)")
        }
    }
    
    // MARK: - Refresh
    func refresh() async {
        await fetchHomeData()
    }
}
