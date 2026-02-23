//
//  FoodDetailViewModel.swift
//  MyFoodCafe
//
//  Created by irwan on 20/12/25.
//

import Foundation

// MARK: - Food Detail ViewModel
@MainActor
class FoodDetailViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var foodDetail: FoodDetailModel?
    @Published var loadingState: LoadingState = .idle
    @Published var errorMessage: String?
    @Published var quantity: Int = 1
    @Published var showSuccessAlert: Bool = false
    
    // MARK: - Dependencies
    private let repository: FoodRepositoryProtocol
    private let foodId: String
    
    // MARK: - Computed Properties
    var totalPrice: Double {
        guard let price = foodDetail?.price else { return 0 }
        return price * Double(quantity)
    }
    
    // MARK: - Init
    init(
        foodId: String,
        repository: FoodRepositoryProtocol = FoodRepository()
    ) {
        self.foodId = foodId
        self.repository = repository
    }
    
    // MARK: - Fetch Food Detail
    func fetchFoodDetail() async {
        loadingState = .loading
        
        do {
            let detail = try await repository.getFoodDetail(id: foodId)
            self.foodDetail = detail
            self.loadingState = .success
        } catch {
            self.errorMessage = error.localizedDescription
            self.loadingState = .failure(error.localizedDescription)
            print("Error fetching food detail: \(error)")
        }
    }
    
    func refresh() async {
        await fetchFoodDetail()
    }
    
    // MARK: - Quantity Actions
    func increaseQuantity() {
        quantity += 1
    }
    
    func decreaseQuantity() {
        if quantity > 1 {
            quantity -= 1
        }
    }
    
    // MARK: - Add to Cart
    func addToCart(cartManager: CartViewModel) {
        guard let food = foodDetail else { return }
        cartManager.addToCart(
            foodId: food.id,
            name: food.name,
            price: food.price,
            quantity: quantity,
            imageUrl: food.imageUrl,
            restaurantName: food.restaurantName
        )
        quantity = 1
        showSuccessAlert = true
        print("Added \(quantity)x \(foodDetail?.name ?? "") to cart")
    }
}
