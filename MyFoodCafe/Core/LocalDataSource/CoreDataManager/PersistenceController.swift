//
//  PersistenceController.swift
//  MyFoodCafe
//
//  Created by irwan on 29/12/25.
//

import CoreData

struct PersistenceController {
    // Singleton untuk production
    static let shared = PersistenceController()
    
    // Preview instance untuk SwiftUI Preview
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Buat dummy data untuk preview
        for i in 0..<3 {
            let item = CartItem(
                context: viewContext,
                foodId: "food_\(i)",
                name: "Nasi Goreng \(i)",
                price: 25000,
                quantity: Int16(i + 1),
                imageUrl: "https://picsum.photos/400/300?random=\(i)",
                restaurantName: "Warung Sederhana"
            )
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MyFoodCafe")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        // Auto merge changes from parent
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    // Save context
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                print("Error saving context: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
