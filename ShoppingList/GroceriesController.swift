//
//  GroceriesController.swift
//  ShoppingList
//
//  Created by Uldis Zingis on 07/10/16.
//  Copyright © 2016 Uldis Zingis. All rights reserved.
//

import Foundation
import CoreData

class GroceriesController {
    
    static let sharedController = GroceriesController()
    var fetchResultsController: NSFetchedResultsController<Grocery>
    
    init() {
        let fetchRequest: NSFetchRequest<Grocery> = NSFetchRequest(entityName: "Grocery")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "category", ascending: true),NSSortDescriptor(key: "name", ascending: true), NSSortDescriptor(key: "isComplete", ascending: true)]
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "category", cacheName: nil)
        
        do {
            try fetchResultsController.performFetch()
        } catch {
            NSLog("Error performing fetch request: \(error)")
        }
    }
    
    func updateCompleteness(grocery: Grocery) {
        grocery.isComplete = !grocery.isComplete
    }
    
    func create(name: String, category: String) {
        let _ = Grocery(name: name, category: category)
    }
    
    func delete(grocery: Grocery) {
        grocery.managedObjectContext?.delete(grocery)
    }
    
    func save() {
        let moc = CoreDataStack.context
        do {
            try moc.save()
        } catch {
            NSLog("Error saving to persistent store: \(error)")
        }
    }
}
