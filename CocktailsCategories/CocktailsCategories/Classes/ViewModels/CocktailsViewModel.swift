//
//  File.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 22.02.2024.
//

import Foundation

class CocktailsViewModel {
    
    // MARK: Properties
    
    private var cocktailCategories: [CocktailsCategory] = []
    private var cocktailsByCategory: [CocktailsCategory: [CocktailInfo]] = [:]
    
    // MARK: Methods
    
    func getCoctailsCategory() {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "thecocktaildb.com"
        components.path = "/api/json/v1/1/list.php"
        components.queryItems = [
            URLQueryItem(name: "c", value: "list")
        ]
        
        guard let coctailCategoriesURL = components.string else { return }
        guard let url = URL(string: coctailCategoriesURL) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard error  == nil else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            guard let data = data else { return }
            
            do {
                let parse = try JSONDecoder().decode(CocktailsCategoriesWrapper.self, from: data)
                guard let drinks = parse.drinks else { return }
                self.cocktailCategories = drinks
                
                if let firstCategory = self.cocktailCategories.randomElement() {
                    let categoryName = firstCategory.name
                    self.getCoctailsBy(categoryName: categoryName)
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        }).resume()
    }
    
    private func getCoctailsBy(categoryName: String) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "thecocktaildb.com"
        components.path = "/api/json/v1/1/filter.php"
        components.queryItems = [
            URLQueryItem(name: "c", value: categoryName)
        ]
        
        guard let coctailsByCategoryNameURL = components.string else { return }
        guard let url = URL(string: coctailsByCategoryNameURL) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard error  == nil else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            guard let data = data else { return }
            
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
                print(error.localizedDescription)
            }
        }).resume()
    }
    
}

