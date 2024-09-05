//
//  AppDelegate.swift
//  CoinsHero
//
//  Created by Vadim Sorokolit on 04.09.2024.
//
    
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        // Setup root view controller.
        let rootViewController = MenuViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
}

