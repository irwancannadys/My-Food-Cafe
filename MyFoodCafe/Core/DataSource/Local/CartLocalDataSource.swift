//
//  CartLocalDataSource.swift
//  MyFoodCafe
//
//  Created by irwan on 23/02/26.
//

import Foundation
import CoreData

// Protocol
protocol CartLocalDataSourceProtocol {
    func fetchAll() throws -> [CartItem]
    func findByFoodId(_ foodId: String) throws -> CartItem?
    func insert(foodId: String, name: String, price: Double, quantity: Int16, imageUrl: String, restaurantName: String) throws
    func updateQuantity(item: CartItem, quantity: Int16) throws
    func delete(item: CartItem) throws
    func deleteAll(items: [CartItem]) throws
}

// Implementation
class CartLocalDataSource: CartLocalDataSourceProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    // SELECT * ORDER BY addedAt DESC
    func fetchAll() throws -> [CartItem] {
        let request = CartItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CartItem.addedAt, ascending: false)]
        return try context.fetch(request)
    }
    
    // SELECT * WHERE foodId = ?
    func findByFoodId(_ foodId: String) throws -> CartItem? {
        let request = CartItem.fetchRequest()
        request.predicate = NSPredicate(format: "foodId == %@", foodId)
        return try context.fetch(request).first
    }
    
    // INSERT
    func insert(foodId: String, name: String, price: Double, quantity: Int16, imageUrl: String, restaurantName: String) throws {
        _ = CartItem(
            context: context,
            foodId: foodId,
            name: name,
            price: price,
            quantity: quantity,
            imageUrl: imageUrl,
            restaurantName: restaurantName
        )
        try saveContext()
    }
    
    // UPDATE
    func updateQuantity(item: CartItem, quantity: Int16) throws {
        item.quantity = quantity
        try saveContext()
    }
    
    // DELETE single
    func delete(item: CartItem) throws {
        context.delete(item)
        try saveContext()
    }
    
    // DELETE all
    func deleteAll(items: [CartItem]) throws {
        items.forEach { context.delete($0) }
        try saveContext()
    }
    
    // SAVE
    private func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
