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
        self.navController.navigationBar.standardAppearance = appearance
        self.navController.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupNavigationController() {
        let viewModel = CocktailsViewModel()
        let viewController = CocktailsViewController(cocktailsViewModel: viewModel)
        self.navController.viewControllers = [viewController]
        
        self.navController.addCustomBottomLine(color: GlobalConstants.separatorColor, height: GlobalConstants.separatorHeight)
        
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            self.setupNavBarAppearance()
            self.setupNavigationController()
            
            self.window?.rootViewController = self.navController
            self.window = window
            window.makeKeyAndVisible()
            
        }
    }
    
}

// NavBarBotton Line
extension UINavigationController {
    
    func addCustomBottomLine(color: UIColor, height: CGFloat) {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = color
        
        navigationBar.addSubview(lineView)
        
        NSLayoutConstraint.activate([
            lineView.widthAnchor.constraint(equalTo: navigationBar.widthAnchor),
            lineView.heightAnchor.constraint(equalToConstant: height),
            lineView.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor),
            lineView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
        ])
    }
    
}
