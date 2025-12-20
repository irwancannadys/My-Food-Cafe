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
        // Cancel previous task if any
        fetchTask?.cancel()
        
        fetchTask = Task {
            // Jangan set loading kalau sudah ada data (untuk refresh)
            if foods.isEmpty && categories.isEmpty && banners.isEmpty {
                loadingState = .loading
            }
            
            do {
                // Check cancellation
                try Task.checkCancellation()
                
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
                
                // Check cancellation sebelum update
                try Task.checkCancellation()
                
                // Update state
                self.foods = fetchedFoods
                self.categories = fetchedCategories
                self.banners = fetchedBanners
                self.loadingState = .success
                
            } catch is CancellationError {
                // Task cancelled - don't show error
                print("✅ Fetch cancelled (normal behavior)")
                // Keep current state - data lama tetap ditampilkan
            } catch {
                self.errorMessage = error.localizedDescription
                self.loadingState = .failure(error.localizedDescription)
                print("❌ Error fetching home data: \(error)")
            }
        }
        
        await fetchTask?.value
    }
    
    // MARK: - Refresh
    func refresh() async {
        await fetchHomeData()
    }
}
