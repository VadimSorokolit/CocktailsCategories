//
//  SceneDelegate.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 21.02.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private let navController = UINavigationController()
    
    private func setupNavBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.shadowImage = UIImage()
        appearance.shadowColor = GlobalConstants.navigationBarColor
        appearance.backgroundColor = GlobalConstants.navigationBarColor
        navController.navigationBar.standardAppearance = appearance
        navController.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupNavigationController() {
        let viewController = CocktailsViewController(cocktailsViewModel: CocktailsViewModel())
        navController.viewControllers = [viewController]
        
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            self.setupNavBarAppearance()
            self.setupNavigationController()
            
            window.rootViewController = navController
            self.window = window
            window.makeKeyAndVisible()
        }
        
    }
    
}
