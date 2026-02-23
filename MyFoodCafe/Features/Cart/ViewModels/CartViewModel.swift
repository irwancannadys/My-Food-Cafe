//
//  CartViewModel.swift
//  MyFoodCafe
//
//  Created by irwan on 23/02/26.
//

import Foundation
import Combine

@MainActor
class CartViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = []
    @Published var totalAmount: Double = 0
    @Published var totalItems: Int = 0
    
    // Sekarang lewat repository, bukan context langsung
    private let repository: CartRepositoryProtocol
    
    init(repository: CartRepositoryProtocol = CartRepository()) {
        self.repository = repository
        fetchCartItems()
    }
    
    func fetchCartItems() {
        do {
            cartItems = try repository.getCartItems()
            calculateTotals()
        } catch {
            print("Error fetching cart items: \(error)")
        }
    }
    
    func addToCart(foodId: String, name: String, price: Double, quantity: Int, imageUrl: String, restaurantName: String) {
        do {
            try repository.addToCart(
                foodId: foodId,
                name: name,
                price: price,
                quantity: quantity,
                imageUrl: imageUrl,
                restaurantName: restaurantName
            )
            fetchCartItems()
        } catch {
            print("Error adding to cart: \(error)")
        }
    }
    
    func increaseQuantity(item: CartItem) {
        do {
            try repository.increaseQuantity(item: item)
            calculateTotals()
        } catch {
            print("Error increasing quantity: \(error)")
        }
    }
    
    func decreaseQuantity(item: CartItem) {
        do {
            try repository.decreaseQuantity(item: item)
            calculateTotals()
        } catch {
            print("Error decreasing quantity: \(error)")
        }
    }
    
    func updateQuantity(item: CartItem, quantity: Int) {
        do {
            try repository.updateQuantity(item: item, quantity: quantity)
            fetchCartItems()
        } catch {
            print("Error updating quantity: \(error)")
        }
    }
    
    func removeItem(_ item: CartItem) {
        do {
            try repository.removeItem(item)
            fetchCartItems()
        } catch {
            print("Error removing item: \(error)")
        }
    }
    
    func clearCart() {
        do {
            try repository.clearCart(items: cartItems)
            fetchCartItems()
        } catch {
            print("Error clearing cart: \(error)")
        }
    }
    
    func isInCart(foodId: String) -> Bool {
        return (try? repository.isInCart(foodId: foodId)) ?? false
    }
    
    func getQuantity(foodId: String) -> Int {
        return (try? repository.getQuantity(foodId: foodId)) ?? 0
    }
    
    private func calculateTotals() {
        totalItems = cartItems.reduce(0) { $0 + Int($1.quantity) }
        totalAmount = cartItems.reduce(0) { $0 + $1.totalPrice }
    }
}
