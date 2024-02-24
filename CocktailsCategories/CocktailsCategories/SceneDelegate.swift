//
//  SceneDelegate.swift
//  CocktailsCategories
//
//  Created by Vadim  on 21.02.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let cocktailsViewController = CocktailsViewController()
        window?.rootViewController = UINavigationController(rootViewController: cocktailsViewController)
        window?.makeKeyAndVisible()
    }
    
}

