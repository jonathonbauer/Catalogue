//
//  AppDelegate.swift
//  Catalogue
//
//  Created by Jonathon Bauer on 2019-10-09.
//  Copyright © 2019 Jonathon Bauer. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties
    var window: UIWindow?
    
    
    // MARK: Persistent Container Creation
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Catalogue")
        
        container.loadPersistentStores(completionHandler: {
            description, error in
            if let error = error {
                fatalError("Error loading the database contents = \(error), description: \(description)")
            }
        })
        return container
    }()
    
    // MARK: Database Save Function
    
    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Could not save the changes to the database \(error)")
            }
        }
    }
    
    // MARK: Launching and Closing the Application
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        // Pass the context into the root viewController
//        print(window?.rootViewController)
////        print(window?.rootViewController as? UINavigationController)
//        
//        if let vc = window?.rootViewController as? UINavigationController {
//            print("true")
//        } else {
//            print("false")
//        }
        
        
//        if let navVC = window?.rootViewController as? UINavigationController,
//            let initialVC = navVC.viewControllers[0] as? LogInVC {
//            print("setting the container")
//            initialVC.container = persistentContainer
//        } else {
//            print("container not set")
//        }
        
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.save()
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

