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
        
        self.setupViews()
        self.loadFirstCategory()
    }
    
    // MARK: Methods
    
    private func setupViews() {
        self.view.backgroundColor = .yellow
        self.title = "Hello !!!"
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 160.0, height: 60.0)
        button.center = self.view.center
        button.backgroundColor = .red
        button.tintColor = .white
        button.layer.cornerRadius = 12.0
        button.layer.masksToBounds = true
        button.setTitle("Get cocktails", for: .normal)
        button.addTarget(self, action: #selector(self.getCocktailsDidTap), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    private func printData(_ category: CocktailsByCategory) {
        let categoryName = category.category.name
        let cocktailsCount = category.cocktails.count
        print(categoryName, cocktailsCount)
    }
    
    private func loadFirstCategory() {
        self.cocktailsViewModel.loadFirstCategory(completion: { (result: Result<CocktailsByCategory, NetworkingError>) in
            switch result {
                case .success(let category):
                    print("----Loaded first category----")
                    self.printData(category)
                case .failure(NetworkingError.noMoreCocktails):
                   print(NetworkingError.noMoreCocktails)
                default:
                    print("Unknown Error")
           }
        })
    }
    
    @objc private func getCocktailsDidTap(withSender sender: UIButton) {
        sender.isEnabled = false
        self.cocktailsViewModel.loadNextCategory(completion: { (result: Result<CocktailsByCategory, NetworkingError>) in
            switch result {
                case .success(let category):
                    sender.isEnabled = true
                    print("----Loaded next category----")
                    self.printData(category)
                case .failure(NetworkingError.noMoreCocktails):
                   print(NetworkingError.noMoreCocktails)
                default:
                    print("Unknown Error")
           }
        })
    }
    
}

