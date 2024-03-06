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
        
        self.setupView()
        self.loadFirstCategory()
    }
    
    // MARK: Methods
    
    private func setupView() {
        self.view.backgroundColor = .yellow
        self.title = "Hello !!!"
        self.setupButton()
    }
    
    private func setupButton() {
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
    
    private func loadFirstCategory() {
        self.cocktailsViewModel.loadFirstCategory(completion: { (result: Result<CocktailsByCategory, NetworkingError>) in
            switch result {
               case .failure(NetworkingError.error(let error)):
                  print(NetworkingError.error(error.localizedDescription as! Error))
                case .failure(NetworkingError.wrongURL):
                    print(NetworkingError.wrongURL)
               case .failure(NetworkingError.invalidURL):
                   print(NetworkingError.invalidURL)
                case .failure(NetworkingError.invalidData):
                    print(NetworkingError.invalidData)
                case .failure(NetworkingError.invalidDecodedData):
                    print(NetworkingError.invalidDecodedData)
                case .failure(.invalidCategories):
                    print(NetworkingError.invalidCategories)
               case .failure(NetworkingError.invalidDrinks):
                    print(NetworkingError.invalidDrinks)
               case .failure(NetworkingError.invalidFirstCategory):
                   print(NetworkingError.invalidFirstCategory)
               case .failure(NetworkingError.noMoreCocktails):
                   print(NetworkingError.noMoreCocktails)
                case .success(_):
                  print("----Loaded first category----")
           }
        })
    }
    
    @objc private func getCocktailsDidTap(withSender sender: UIButton) {
        self.cocktailsViewModel.loadNextCategory(withSender: sender, completion: { (result: Result<CocktailsByCategory, NetworkingError>) in
            switch result {
               case .failure(NetworkingError.error(let error)):
                  print(NetworkingError.error(error.localizedDescription as! Error))
                case .failure(NetworkingError.wrongURL):
                    print(NetworkingError.wrongURL)
               case .failure(NetworkingError.invalidURL):
                   print(NetworkingError.invalidURL)
                case .failure(NetworkingError.invalidData):
                    print(NetworkingError.invalidData)
                case .failure(NetworkingError.invalidDecodedData):
                    print(NetworkingError.invalidDecodedData)
                case .failure(.invalidCategories):
                    print(NetworkingError.invalidCategories)
               case .failure(NetworkingError.invalidDrinks):
                    print(NetworkingError.invalidDrinks)
               case .failure(NetworkingError.invalidFirstCategory):
                   print(NetworkingError.invalidFirstCategory)
               case .failure(NetworkingError.noMoreCocktails):
                   print(NetworkingError.noMoreCocktails)
                case .success(_):
                  print("----Loaded next category----")
           }
        })
    }
    
}

