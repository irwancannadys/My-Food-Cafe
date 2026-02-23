//
//  CartItem+CoreData.swift
//  MyFoodCafe
//
//  Created by irwan on 29/12/25.
//

import Foundation
import CoreData

@objc(CartItem)
public class CartItem: NSManagedObject {
    @NSManaged public var id: String
    @NSManaged public var foodId: String
    @NSManaged public var name: String
    @NSManaged public var price: Double
    @NSManaged public var quantity: Int16
    @NSManaged public var imageUrl: String
    @NSManaged public var restaurantName: String
    @NSManaged public var addedAt: Date
    
    // Computed property
    var totalPrice: Double {
        return price * Double(quantity)
    }
    
    // Convenience initializer
    convenience init(
        context: NSManagedObjectContext,
        foodId: String,
        name: String,
        price: Double,
        quantity: Int16,
        imageUrl: String,
        restaurantName: String
    ) {
        self.init(context: context)
        self.id = UUID().uuidString
        self.foodId = foodId
        self.name = name
        self.price = price
        self.quantity = quantity
        self.imageUrl = imageUrl
        self.restaurantName = restaurantName
        self.addedAt = Date()
    }
}

// MARK: - Identifiable
extension CartItem: Identifiable {
    
}

// MARK: - Fetch Request
extension CartItem {
    static func fetchRequest() -> NSFetchRequest<CartItem> {
        return NSFetchRequest<CartItem>(entityName: "CartItem")
    }
}
