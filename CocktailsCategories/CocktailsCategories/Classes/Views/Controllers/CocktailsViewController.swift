//
//  ViewController.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 21.02.2024.
//

import UIKit

class CocktailsViewController: UIViewController {
    
    let cocktailsViewModel = CocktailsViewModel()
    
    // Load first cocktails on Start!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .yellow
        self.title = "Hello !!!"
        self.setupButton()
        self.cocktailsViewModel.loadFirstCategory(completion: { (completed: Bool) in
            switch completed {
                case true :
                    print("Load first cocktails")
                case false :
                    print("Don't load first cocktails")
            }
        })
    }
    
    // MARK: Methods
    
    private func setupButton() {
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 160.0, height: 60.0)
        button.center = view.center
        button.backgroundColor = .red
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.setTitle("Get cocktails", for: .normal)
        button.addTarget(self, action: #selector(getCocktailsDidTap), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc private func getCocktailsDidTap(_ sender: UIButton) {
        self.cocktailsViewModel.loadNextCategory(completion: { (completed: Bool) in    switch completed {
            case true :
                print("Load new cocktails")
            case false :
                print("Don't load cocktails")
            }
        })
    }
    
}

