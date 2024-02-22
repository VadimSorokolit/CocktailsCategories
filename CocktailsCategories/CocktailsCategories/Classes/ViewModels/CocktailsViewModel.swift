//
//  File.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 22.02.2024.
//

import Foundation

class CocktailsViewModel {
    
    var cocktailCategories: [CocktailsCategory] = []
    var cocktailsByCategory: [CocktailsCategory: [CocktailInfo]] = [:]
    
    func getCoctailsCategory() {
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            guard error == nil else { return }
            
            do {
                let parse = try JSONDecoder().decode(CocktailsCategoriesWrapper.self, from: data)
                guard let drinks = parse.drinks else { return }
                self.cocktailCategories = drinks
                
                if let firstCategory = self.cocktailCategories.randomElement() {
                    let categoryName = firstCategory.name
                    self.getCoctailsBy(categoryName: categoryName)
                }
                
            } catch let error {
                print("ERROR - \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func getCoctailsBy(categoryName: String) {
        
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=\(categoryName)") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            guard error == nil else { return }
            
            do {
                let parse = try JSONDecoder().decode(CocktailsListWrapper.self, from: data)
                guard let drinks = parse.drinks else { return }
                
                print(categoryName, "(\(drinks.count))")
                
                for drink in drinks {
                    if let drinkName = drink.name {
                        print("....\(drinkName)")
                    }
                }
                
            } catch let error {
                print("ERROR - \(error.localizedDescription)")
            }
        }.resume()
    }
    
}


