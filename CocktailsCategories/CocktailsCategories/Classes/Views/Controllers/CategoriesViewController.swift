//
//  CategoriesViewController.swift
//  CocktailsCategories
//
//  Created by Vadim  on 14.03.2024.
//

import UIKit

class CategoriesViewController: UIViewController {
    
//    let cocktailsViewModel: CocktailsViewModel
//    
//    init(viewModel: CocktailsViewModel) {
//        self.cocktailsViewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    private lazy var applyFiltersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply Filters", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .yellow
        self.setupNavBar()
        self.view.addSubview(applyFiltersButton)
        self.setupLayout()

    }
    
    private func setupNavBar() {
        navigationItem.title = NSLocalizedString("Filters", comment: "")
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupLayout() {
        self.applyFiltersButton.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: self.applyFiltersButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 32.0)
        let rightConstraint = NSLayoutConstraint(item: self.applyFiltersButton, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -32.0)
        let bottomConstraint = NSLayoutConstraint(item: self.applyFiltersButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: -5.0)
        bottomConstraint.isActive = true
        let heightConstraint = self.applyFiltersButton.heightAnchor.constraint(equalToConstant: 50) 
        heightConstraint.isActive = true
        view.addConstraint(leftConstraint)
        view.addConstraint(rightConstraint)
        view.addConstraint(bottomConstraint)
        
    }
    

    
}
