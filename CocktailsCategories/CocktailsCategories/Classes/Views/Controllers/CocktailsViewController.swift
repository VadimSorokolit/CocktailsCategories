//
//  ViewController.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 21.02.2024.
//

import UIKit

class CocktailsViewController: UIViewController, UITextFieldDelegate {
    
    let cocktailsViewModel = CocktailsViewModel()
    
    private lazy var nameTextField: UITextField = {
        let inputTextField = UITextField(frame:CGRectMake(116.5, 200.0, 160.0, 60.0))
        inputTextField.backgroundColor = .green
        inputTextField.layer.cornerRadius = 12.0
        inputTextField.textColor = .black
        inputTextField.layer.masksToBounds = true
        inputTextField.font = .boldSystemFont(ofSize: 10.0)
        inputTextField.delegate = self
        inputTextField.placeholder = "Input categories to show"
        inputTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20, height: 40))
        inputTextField.leftViewMode = .always
        return inputTextField
    }()
    
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
        
        self.view.addSubview(nameTextField)
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 160.0, height: 60.0)
        button.center = self.view.center
        button.backgroundColor = .blue
        button.tintColor = .white
        button.layer.cornerRadius = 12.0
        button.layer.masksToBounds = true
        button.setTitle("Get cocktails", for: .normal)
        button.addTarget(self, action: #selector(self.getCocktailsDidTap), for: .touchUpInside)
        self.view.addSubview(button)
        
        let applyButton = UIButton(type: .system)
        applyButton.frame = CGRect(x: 116.5, y: 600.0, width: 160.0, height: 60.0)
        applyButton.backgroundColor = .red
        applyButton.layer.cornerRadius = 12.0
        applyButton.tintColor = .white
        applyButton.layer.masksToBounds = true
        applyButton.setTitle("Apply filter", for: .normal)
        applyButton.addTarget(self, action: #selector(self.getFilteredCocktailsDidTap), for: .touchUpInside)
        self.view.addSubview(applyButton)
        
    }
    
    private func printData(_ category: CocktailsByCategory) {
        let categoryName = category.category.name
        let cocktailsCount = category.cocktails.count
        let resultFormatedString = String(format: "CATEGORY: %@  COUNT OF COCKTAILS ARE: %d", arguments: [categoryName, cocktailsCount])
        print(resultFormatedString)
    }
    
    private func printFilteredCategory(_ category: CocktailsByCategory) {
            let categoryName = category.category.name
            let cocktailsCount = category.cocktails.count
            let resultFormatedString = String(format: "CATEGORY: %@  COUNT OF COCKTAILS ARE: %d", arguments: [categoryName, cocktailsCount])
            print(resultFormatedString)
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
    
    private func loadNextCagegory(withSender sender: UIButton) {
        self.cocktailsViewModel.loadNextCategory(completion: { (result: Result<CocktailsByCategory, NetworkingError>) in
            switch result {
                case .success(let category):
                    print("----Loaded next category----")
                    self.printData(category)
                    DispatchQueue.main.async(execute: {
                        sender.isEnabled = true
                    })
                case .failure(NetworkingError.noMoreCocktails):
                   print(NetworkingError.noMoreCocktails)
                default:
                    print("Unknown Error")
           }
        })
    }
    
    @objc private func getCocktailsDidTap(withSender sender: UIButton) {
        sender.isEnabled = false
        loadNextCagegory(withSender: sender)
    }
    
    @objc private func showFilteredCocktailsDidTap(_ text: UITextField) {
        var intNumbers: [String] = []
        var myNumbers: [Int] = []
        if nameTextField.hasText {
            if let string = nameTextField.text {
                let intString = "1234567890"
                for character in string {
                    if intString.contains(character) {
                        intNumbers.append(String(character))
                    }
                }
                let numbers = Array(Set(intNumbers))
                myNumbers = numbers.compactMap { Int($0) }
            }
        } else {
            print("Plese input number cocktail categories")
        }
        for number in myNumbers {
            if number >= 1 {
                let index = number - 1
            let filteredCategory = self.cocktailsViewModel.filteredCocktailsByCategory[index]
                printFilteredCategory(filteredCategory)
            }
        }

    }
}

