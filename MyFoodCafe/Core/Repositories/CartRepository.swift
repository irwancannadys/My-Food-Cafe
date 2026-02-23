//
//  CartRepository.swift
//  MyFoodCafe
//
//  Created by irwan on 23/02/26.
//

import Foundation

// Protocol
protocol CartRepositoryProtocol {
    func getCartItems() throws -> [CartItem]
    func addToCart(foodId: String, name: String, price: Double, quantity: Int, imageUrl: String, restaurantName: String) throws
    func updateQuantity(item: CartItem, quantity: Int) throws
    func increaseQuantity(item: CartItem) throws
    func decreaseQuantity(item: CartItem) throws
    func removeItem(_ item: CartItem) throws
    func clearCart(items: [CartItem]) throws
    func isInCart(foodId: String) throws -> Bool
    func getQuantity(foodId: String) throws -> Int
}

// Implementation
class CartRepository: CartRepositoryProtocol {
    private let localDataSource: CartLocalDataSourceProtocol
    
    init(localDataSource: CartLocalDataSourceProtocol = CartLocalDataSource()) {
        self.localDataSource = localDataSource
    }
    
    func getCartItems() throws -> [CartItem] {
        return try localDataSource.fetchAll()
    }
    
    func addToCart(foodId: String, name: String, price: Double, quantity: Int, imageUrl: String, restaurantName: String) throws {
        // Cek dulu apakah sudah ada
        if let existing = try localDataSource.findByFoodId(foodId) {
            // Update quantity
            try localDataSource.updateQuantity(item: existing, quantity: existing.quantity + Int16(quantity))
        } else {
            // Insert baru
            try localDataSource.insert(
                foodId: foodId,
                name: name,
                price: price,
                quantity: Int16(quantity),
                imageUrl: imageUrl,
                restaurantName: restaurantName
            )
        }
    }
    
    func updateQuantity(item: CartItem, quantity: Int) throws {
        if quantity <= 0 {
            try localDataSource.delete(item: item)
        } else {
            try localDataSource.updateQuantity(item: item, quantity: Int16(quantity))
        }
    }
    
    func increaseQuantity(item: CartItem) throws {
        try localDataSource.updateQuantity(item: item, quantity: item.quantity + 1)
    }
    
    func decreaseQuantity(item: CartItem) throws {
        if item.quantity > 1 {
            try localDataSource.updateQuantity(item: item, quantity: item.quantity - 1)
        }
    }
    
    func removeItem(_ item: CartItem) throws {
        try localDataSource.delete(item: item)
    }
    
    func clearCart(items: [CartItem]) throws {
        try localDataSource.deleteAll(items: items)
    }
    
    func isInCart(foodId: String) throws -> Bool {
        return try localDataSource.findByFoodId(foodId) != nil
    }
    
    func getQuantity(foodId: String) throws -> Int {
        return Int(try localDataSource.findByFoodId(foodId)?.quantity ?? 0)
    }
}
