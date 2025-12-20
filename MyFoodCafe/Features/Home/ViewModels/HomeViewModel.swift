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
    
    // MARK: - Task tracking
    private var fetchTask: Task<Void, Never>?
    
    // MARK: - Init
    init(repository: FoodRepositoryProtocol = FoodRepository()) {
        self.repository = repository
    }
    
    // MARK: - Fetch All Home Data
    func fetchHomeData() async {
        print("🔵 [fetchHomeData] START - Setting loading state")
        loadingState = .loading
        
        do {
            print("🔵 [fetchHomeData] Fetching foods, categories, and banners in parallel...")
            
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
            
            print("🟢 [fetchHomeData] SUCCESS - Fetched:")
            print("   - Foods: \(fetchedFoods.count) items")
            print("   - Categories: \(fetchedCategories.count) items")
            print("   - Banners: \(fetchedBanners.count) items")
            
            // Update state
            self.foods = fetchedFoods
            self.categories = fetchedCategories
            self.banners = fetchedBanners
            self.loadingState = .success
            
            print("🟢 [fetchHomeData] State updated to SUCCESS")
            
        } catch {
            print("🔴 [fetchHomeData] ERROR: \(error)")
            self.errorMessage = error.localizedDescription
            self.loadingState = .failure(error.localizedDescription)
        }
    }

    // MARK: - Refresh (untuk pull to refresh)
    func refresh() async {
        print("🔄 [refresh] START - Pull to refresh triggered")
        print("🔄 [refresh] Current data count before refresh:")
        print("   - Foods: \(foods.count)")
        print("   - Categories: \(categories.count)")
        print("   - Banners: \(banners.count)")
        
        do {
            print("🔄 [refresh] Fetching new data...")
            
            async let foodsResult = repository.getFoods()
            async let categoriesResult = repository.getCategories()
            async let bannersResult = repository.getBanners()
            
            let (fetchedFoods, fetchedCategories, fetchedBanners) = try await (
                foodsResult,
                categoriesResult,
                bannersResult
            )
            
            print("🟢 [refresh] SUCCESS - Fetched new data:")
            print("   - Foods: \(fetchedFoods.count) items")
            print("   - Categories: \(fetchedCategories.count) items")
            print("   - Banners: \(fetchedBanners.count) items")
            
            self.foods = fetchedFoods
            self.categories = fetchedCategories
            self.banners = fetchedBanners
            
            print("🟢 [refresh] Data updated successfully!")
            
        } catch {
            print("🔴 [refresh] ERROR: \(error)")
            // Silent error untuk refresh
        }
    }
    
    var displayedFoods: [FoodModel] {
        return Array(foods.prefix(3))
    }
}
