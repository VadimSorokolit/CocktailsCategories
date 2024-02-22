//
//  File.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 22.02.2024.
//

import Foundation


var cocktailsCategories: [CocktailsCategory] = []
var cocktailsListsByCategories: [CocktailsCategory : [CocktailInfo]] = [:]
var result: ((Result<Void, Error>) -> Void)?

func getCoctailsCategory() {
    guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list") else { return }
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else { return }
        guard error == nil else { return }
        
        do {
            let parse = try JSONDecoder().decode(CocktailsCategoriesWrapper.self, from: data)
            guard let _parse = parse.drinks else { return }
            cocktailsCategories = _parse
            
            for drink in cocktailsCategories {
                print(drink.name)
            }
            
            
        } catch let error {
            print("ERROR - \(error)")
        }
    }.resume()
}

func getCoctailsBy(category: String) {
    var isCategory = false
    for drink in cocktailsCategories {
        if drink.name .contains(category) {
        isCategory = true
            break
        } else {
            continue
        }
    }
    if isCategory {
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=\(category)") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            guard error == nil else { return }
            
            do {
                let parse = try JSONDecoder().decode(CocktailsListWrapper.self, from: data)
                guard let _parse = parse.drinks else { return }
                
                for drink in _parse {
                    if let drinkName = drink.name {
                        print(drinkName)
                    }
                }
                
            } catch let error {
                print("ERROR - \(error)")
            }
        }.resume()
    } else {
        print("It's coctail category does't present in db")
    }
}



