//
//  AppDelegate.swift
//  ShoppingList
//
//  Created by Uldis Zingis on 07/10/16.
//  Copyright © 2016 Uldis Zingis. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationDidEnterBackground(_ application: UIApplication) {
        GroceriesController.sharedController.save()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        GroceriesController.sharedController.save()
    }
}

