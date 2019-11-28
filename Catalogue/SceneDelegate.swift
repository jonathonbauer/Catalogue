//
//  SceneDelegate.swift
//  Catalogue
//
//  Created by Jonathon Bauer on 2019-10-09.
//  Copyright © 2019 Jonathon Bauer. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var initialViewController: UIViewController?
    var db: DBHelper?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
     
        if db == nil {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            db = appDelegate.dbHelper
        }
        
//        guard let db = db else { return }
        
        // Set the initial view controller based on if Bypass Login has been enabled,
//        if(db.getSettings().bypassLogin) {
//            // Ensure we are a guest if bypassing login
//            db.getSettings().isGuest = true
//
//            initialViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarController") as! UITabBarController
//        } else {
//            initialViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "LogInVC") as! LogInVC
//        }
        
//        
//        // set the rootViewController here using window instance
//        self.window?.rootViewController = initialViewController
        
        
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

