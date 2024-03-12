//
//  ViewController.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 21.02.2024.
//

import UIKit

class CocktailsViewController: UIViewController, UITextFieldDelegate {
    
    private let cocktailsViewModel = CocktailsViewModel()
    
    private lazy var inputTextField: UITextField = {
        let inputTextField = UITextField()
        inputTextField.frame = CGRectMake(116.5, 200.0, 160.0, 60.0)
        inputTextField.backgroundColor = .green
        inputTextField.layer.cornerRadius = 12.0
        inputTextField.textColor = .black
        inputTextField.layer.masksToBounds = true
        inputTextField.font = .boldSystemFont(ofSize: 17.0)
        inputTextField.delegate = self
        inputTextField.placeholder = "Input categories to show"
        inputTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20, height: 40))
        inputTextField.leftViewMode = .always
        return inputTextField
    }()
    
    private lazy var loadNextButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 160.0, height: 60.0)
        button.center = self.view.center
        button.backgroundColor = .blue
        button.tintColor = .white
        button.layer.cornerRadius = 12.0
        button.layer.masksToBounds = true
        button.setTitle("Get cocktails", for: .normal)
        button.addTarget(self, action: #selector(self.loadNextButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 116.5, y: 600.0, width: 160.0, height: 60.0)
        button.backgroundColor = .red
        button.layer.cornerRadius = 12.0
        button.tintColor = .white
        button.layer.masksToBounds = true
        button.setTitle("Apply filter", for: .normal)
        button.addTarget(self, action: #selector(self.applyButtonDidTap), for: .touchUpInside)
        return button
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
        
        self.view.addSubview(self.inputTextField)
        self.view.addSubview(self.loadNextButton)
        self.view.addSubview(self.applyButton)
    }

    private func printCategories(_ categories: [CocktailsByCategory]) {
        for category in categories {
            let categoryName = category.category.name
            let cocktailsCount = category.cocktails.count
            let resultFormatedString = String(format: "CATEGORY: %@  COUNT OF COCKTAILS ARE: %d", arguments: [categoryName, cocktailsCount])
            print(resultFormatedString)
        }
    }
    
    private func loadFirstCategory() {
        self.cocktailsViewModel.loadFirstCategory(completion: { (result: Result<CocktailsByCategory, NetworkingError>) -> Void in
            switch result {
                case .success(let category):
                    print("----Loaded first category----")
                    self.printCategories([category])
                case .failure(NetworkingError.noMoreCocktails):
                    print(NetworkingError.noMoreCocktails)
                default:
                    print("Unknown Error")
            }
        })
    }
    
    private func loadNextCagegory(completion: @escaping () -> Void) {
        self.cocktailsViewModel.loadNextCategory(completion: { (result: Result<CocktailsByCategory, NetworkingError>) -> Void in
            switch result {
                case .success(let category):
                    print("----Loaded next category----")
                    self.printCategories([category])
                    completion()
                case .failure(NetworkingError.noMoreCocktails):
                    print(NetworkingError.noMoreCocktails)
                default:
                    print("Unknown Error")
            }
        })
    }
    
    private func filterCagegories() {
        guard let text = self.inputTextField.text, Int(text) != nil else {
            print("Please input number")
            return
        }
        let stringNumber = text
        
        self.cocktailsViewModel.filterCagegories(by: stringNumber, completion: { (notExistIndices: [Int]) -> Void in
            if !notExistIndices.isEmpty {
                print("Wasn't load categories by indices: \(notExistIndices)")
            }
            let categories = self.cocktailsViewModel.filteredCategories
            self.printCategories(categories)
        })
    }
    
    @objc private func loadNextButtonDidTap(withSender sender: UIButton) {
        sender.isEnabled = false
        self.loadNextCagegory(completion: { () -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                sender.isEnabled = true
            })
        })
    }
    
    @objc private func applyButtonDidTap(_ textField: UITextField) {
        self.filterCagegories()
    }
    
}

