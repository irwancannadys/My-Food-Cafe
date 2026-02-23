//
//  CartManager.swift
//  MyFoodCafe
//
//  Created by irwan on 29/12/25.
//

import Foundation
import CoreData
import Combine

@MainActor
class CartManager: ObservableObject {
    @Published var cartItems: [CartItem] = []
    @Published var totalAmount: Double = 0
    @Published var totalItems: Int = 0
    
    private let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
        fetchCartItems()
    }
    
    // MARK: - Fetch Cart Items
    func fetchCartItems() {
        let request = CartItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CartItem.addedAt, ascending: false)]
        
        do {
            cartItems = try viewContext.fetch(request)
            calculateTotals()
        } catch {
            print("Error fetching cart items: \(error)")
        }
    }
    
    // MARK: - Add to Cart
    func addToCart(
        foodId: String,
        name: String,
        price: Double,
        quantity: Int,
        imageUrl: String,
        restaurantName: String
    ) {
        // Check if item already exists
        let request = CartItem.fetchRequest()
        request.predicate = NSPredicate(format: "foodId == %@", foodId)
        
        do {
            let results = try viewContext.fetch(request)
            
            if let existingItem = results.first {
                // Update quantity
                existingItem.quantity += Int16(quantity)
            } else {
                // Create new item
                _ = CartItem(
                    context: viewContext,
                    foodId: foodId,
                    name: name,
                    price: price,
                    quantity: Int16(quantity),
                    imageUrl: imageUrl,
                    restaurantName: restaurantName
                )
            }
            
            saveContext()
            fetchCartItems()
        } catch {
            print("Error adding to cart: \(error)")
        }
    }
    
    // MARK: - Update Quantity
    func updateQuantity(item: CartItem, quantity: Int) {
        if quantity <= 0 {
            removeItem(item)
        } else {
            item.quantity = Int16(quantity)
            saveContext()
            calculateTotals()
        }
    }
    
    // MARK: - Increase Quantity
    func increaseQuantity(item: CartItem) {
        item.quantity += 1
        saveContext()
        calculateTotals()
    }
    
    // MARK: - Decrease Quantity
    func decreaseQuantity(item: CartItem) {
        if item.quantity > 1 {
            item.quantity -= 1
            saveContext()
            calculateTotals()
        }
    }
    
    // MARK: - Remove Item
    func removeItem(_ item: CartItem) {
        viewContext.delete(item)
        saveContext()
        fetchCartItems()
    }
    
    // MARK: - Clear Cart
    func clearCart() {
        for item in cartItems {
            viewContext.delete(item)
        }
        saveContext()
        fetchCartItems()
    }
    
    // MARK: - Calculate Totals
    private func calculateTotals() {
        totalItems = cartItems.reduce(0) { $0 + Int($1.quantity) }
        totalAmount = cartItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    // MARK: - Save Context
    private func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Error saving context: \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - Helper Methods
    func isInCart(foodId: String) -> Bool {
        return cartItems.contains(where: { $0.foodId == foodId })
    }
    
    func getQuantity(foodId: String) -> Int {
        return Int(cartItems.first(where: { $0.foodId == foodId })?.quantity ?? 0)
    }
}
