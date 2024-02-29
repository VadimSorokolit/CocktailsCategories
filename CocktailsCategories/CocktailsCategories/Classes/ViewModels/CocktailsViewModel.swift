//
//  File.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 22.02.2024.
//

import Foundation

struct CocktailsByCategory {
    let category: CocktailsCategory
    let cocktails: [CocktailInfo]
}

class CocktailsViewModel {
    
    // MARK: Properties
    
    var cocktailCategories: [CocktailsCategory] = []
    var categories = [CocktailsByCategory]()
    private var cocktailsByCategory: [CocktailsCategory: [CocktailInfo]] = [:]
    
    // MARK: Methods
    
    private func getCocktailCategories(completion: @escaping (Result<[CocktailsCategory], Error>) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "thecocktaildb.com"
        components.path = "/api/json/v1/1/list.php"
        components.queryItems = [
            URLQueryItem(name: "c", value: "list")
        ]
        
        guard let cocktailCategoriesURL = components.string else { return }
        guard let url = URL(string: cocktailCategoriesURL) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard error  == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data else { return }
            
            do {
                let parse = try JSONDecoder().decode(CocktailsCategoriesWrapper.self, from: data)
                guard let drinks = parse.drinks else { return }
                completion(Result.success(drinks))
            } catch let error {
                completion(Result.failure(error))
            }
        }).resume()
    }
    
    private func getCoctailsBy(categoryName: String, completion: @escaping (Result<[CocktailInfo], Error>) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "thecocktaildb.com"
        components.path = "/api/json/v1/1/filter.php"
        components.queryItems = [
            URLQueryItem(name: "c", value: categoryName)
        ]
        
        guard let cocktailsByCategoryNameURL = components.string else { return }
        guard let url = URL(string: cocktailsByCategoryNameURL) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard error  == nil else {
                if let error = error {
                    completion(Result.failure(error))
                }
                return
            }
            guard let data = data else { return }
            
            do {
                let parse = try JSONDecoder().decode(CocktailsListWrapper.self, from: data)
                guard let drinks = parse.drinks else { return }
                completion(Result.success(drinks))
                
            } catch let error {
                completion(Result.failure(error))
            }
        }).resume()
    }
    
    func loadFirstCategory(completion: @escaping (Bool) -> Void) {
        
        self.getCocktailCategories(completion: { (result: Result<[CocktailsCategory], Error>) in
            switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let drinks):
                    self.cocktailCategories = drinks
                    guard let firstCategory = self.cocktailCategories.first else { completion(false)
                        return
                    }
                    let firstCategoryName = firstCategory.name
                    self.getCoctailsBy(categoryName: firstCategoryName, completion: { (result: Result<[CocktailInfo], Error>) in
                        switch result {
                            case .failure(let error):
                                print(error.localizedDescription)
                            case .success(let drinks):
                                completion(true)
                                let newCategory = CocktailsByCategory(category: firstCategory, cocktails: drinks)
                                self.categories.append(newCategory)
                                print(firstCategoryName, drinks.count)
                                drinks.forEach { drink in
                                    if let drinkName  = drink.name{
                                        print(".....\(drinkName)")
                                    }
                                }
                        }
                    })
            }
        })
        
        }
        
    func loadNextCategory(completion: @escaping (Bool) -> Void) {
        
        let nextIndex = self.categories.count
        if self.cocktailCategories.indices.contains(nextIndex) {
            let nextCategory = self.cocktailCategories[nextIndex]
            let nextCategoryName = nextCategory.name
            self.getCoctailsBy(categoryName: nextCategoryName, completion: { (result: Result<[CocktailInfo], Error>) in
                switch result {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .success(let drinks):
                        let newCategory = CocktailsByCategory(category: nextCategory, cocktails: drinks)
                        self.categories.append(newCategory)
                        print(nextCategoryName, drinks.count)
                        drinks.forEach { drink in
                            if let drinkName  = drink.name{
                                print(".....\(drinkName)")
                            }
                        }
                }
                completion(true)
            })
        } else {
            completion(false)
        }
    }
    
}


