//
//  Grocery+Convenience.swift
//  ShoppingList
//
//  Created by Uldis Zingis on 07/10/16.
//  Copyright © 2016 Uldis Zingis. All rights reserved.
//

import Foundation
import CoreData

extension Grocery {
    convenience init(name: String, category: String?, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        if let category = category { self.category = category }
    }
}
