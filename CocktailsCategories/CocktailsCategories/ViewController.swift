//
//  ViewController.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 21.02.2024.
//

import UIKit

class ViewController: UIViewController {
    
    let cocktailsViewModel = CocktailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
        self.title = "Good !!!"
        cocktailsViewModel.getCoctailsCategory()
    }

}

