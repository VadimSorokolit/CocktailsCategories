//
//  ViewController.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 21.02.2024.
//

import UIKit

class CocktailsViewController: UIViewController {
    
    let cocktailsViewModel = CocktailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .yellow
        self.title = "Good !!!"
        self.myButton()
        cocktailsViewModel.getCoctailsCategory()
    }
    
    // MARK: Methods
    
    private func myButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 160, height: 60))
        button.center = view.center
        button.backgroundColor = .red
        button.layer.cornerRadius = 12
        button.setTitle("First button", for: .normal)
        button.layer.masksToBounds = true
        view.addSubview(button)
    }
    
}

