//
//  ViewController.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 21.02.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getCoctailsCategory()
        getCoctailsBy(category: "Ordinary_Drink")
    }

}

