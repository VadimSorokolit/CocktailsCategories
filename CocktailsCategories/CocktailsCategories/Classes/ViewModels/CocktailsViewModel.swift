//
//  File.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 22.02.2024.
//

import Foundation
import UIKit

enum NetworkingError: Error {
    case wrongURL
    case invalidURL
    case invalidCategories
    case invalidDecodedData
    case invalidDrinks
    case invalidData
    case invalidFirstCategory
    case noMoreCocktails
    case error(Error)
}

struct CocktailsByCategory {
    let category: Category
    let cocktails: [Cocktail]
}

class CocktailsViewModel {
    
    // MARK: Properties
    
    var categories: [Category] = []
    var cocktailsByCategory = [CocktailsByCategory]()
    
    // MARK: - Methods
    
    // MARK: Get all categories
    
    private func getCategories(completion: @escaping (Result<[Category], NetworkingError>) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "thecocktaildb.com"
        components.path = "/api/json/v1/1/list.php"
        components.queryItems = [
            URLQueryItem(name: "c", value: "list")
        ]
        
        guard let urlString = components.string else {
            completion(.failure(NetworkingError.wrongURL))
            return
        }
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkingError.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let error {
                completion(.failure(NetworkingError.error(error)))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkingError.invalidData))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(CocktailsCategoriesWrapper.self, from: data)
                guard let categories = decodedData.drinks else {
                   completion(.failure(NetworkingError.invalidDecodedData))

                    return
                }
                completion(Result.success(categories))
            } catch let error {
                completion(Result.failure(NetworkingError.error(error)))
            }
        }).resume()
    }
    
    
    // MARK: Get Cocktails List by Category
    
    private func getCoctails(by categoryName: String, completion: @escaping (Result<[Cocktail], NetworkingError>) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "thecocktaildb.com"
        components.path = "/api/json/v1/1/filter.php"
        components.queryItems = [
            URLQueryItem(name: "c", value: categoryName)
        ]
        guard let urlString = components.string else {
            completion(.failure(NetworkingError.wrongURL))
            return
        }
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkingError.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let error {
                completion(Result.failure(NetworkingError.error(error)))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkingError.invalidData))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(CocktailsListWrapper.self, from: data)
                guard let drinks = decodedData.drinks else {
                   completion(.failure(NetworkingError.invalidDecodedData))
                    return
                }
                completion(Result.success(drinks))
            } catch let error {
                completion(Result.failure(NetworkingError.error(error)))
            }
        }).resume()
    }
    
    // MARK: Get first category
    
    func loadFirstCategory(completion: @escaping (Result<CocktailsByCategory, NetworkingError>) -> Void) {
        self.getCategories(completion: { (result: Result<[Category], NetworkingError>) -> Void in
            switch result {
                case .failure(NetworkingError.error(let error)):
                    completion(.failure(NetworkingError.error(error)))
                case .failure(NetworkingError.wrongURL):
                    completion(.failure(NetworkingError.wrongURL))
                case .failure(NetworkingError.invalidURL):
                    completion(.failure(NetworkingError.invalidURL))
                case .failure(NetworkingError.invalidData):
                    completion(.failure(NetworkingError.invalidData))
                case .failure(NetworkingError.invalidDecodedData):
                    completion(.failure(NetworkingError.invalidDecodedData))
                case .failure(.invalidCategories):
                    completion(.failure(NetworkingError.invalidCategories))
                case .failure(NetworkingError.invalidDrinks):
                    completion(.failure(NetworkingError.invalidDrinks))
                case .failure(NetworkingError.invalidFirstCategory):
                    completion(.failure(NetworkingError.invalidFirstCategory))
                case .failure(NetworkingError.noMoreCocktails):
                    completion(.failure(NetworkingError.noMoreCocktails))
                case .success(let categories):
                    self.categories = categories
                    guard let firstCategory = self.categories.first else { 
                        completion(.failure(NetworkingError.invalidFirstCategory))
                        return
                    }
                    self.getCoctails(by: firstCategory.name, completion: { (result: Result<[Cocktail], NetworkingError>) -> Void in
                        switch result {
                            case .failure(NetworkingError.error(let error)):
                                completion(.failure(NetworkingError.error(error)))
                            case .failure(NetworkingError.wrongURL):
                                completion(.failure(NetworkingError.wrongURL))
                            case .failure(NetworkingError.invalidURL):
                                completion(.failure(NetworkingError.invalidURL))
                            case .failure(NetworkingError.invalidData):
                                completion(.failure(NetworkingError.invalidData))
                            case .failure(NetworkingError.invalidDecodedData):
                                completion(.failure(NetworkingError.invalidDecodedData))
                            case .failure(.invalidCategories):
                                completion(.failure(NetworkingError.invalidCategories))
                            case .failure(NetworkingError.invalidDrinks):
                                completion(.failure(NetworkingError.invalidDrinks))
                            case .failure(NetworkingError.invalidFirstCategory):
                                completion(.failure(NetworkingError.invalidFirstCategory))
                            case .failure(NetworkingError.noMoreCocktails):
                                completion(.failure(NetworkingError.noMoreCocktails))
                            case .success(let drinks):
                                let newCategory = CocktailsByCategory(category: firstCategory, cocktails: drinks)
                                completion(.success(newCategory))
                                self.cocktailsByCategory.append(newCategory)
                                print(firstCategory.name, drinks.count)
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
    
    // MARK: Get next category
    
    func loadNextCategory(withSender sender: UIButton, completion: @escaping (Result<CocktailsByCategory, NetworkingError>) -> Void) {
            let nextIndex = self.cocktailsByCategory.count
                    let isNextCategoryExist = self.categories.indices.contains(nextIndex)
                    if isNextCategoryExist {
                        let nextCategory = self.categories[nextIndex]
                        self.getCoctails(by: nextCategory.name, completion: { (result: Result<[Cocktail], NetworkingError>) in
                            switch result {
                                case .failure(NetworkingError.error(let error)):
                                    sender.isEnabled = false
                                    completion(.failure(NetworkingError.error(error)))
                                case .failure(NetworkingError.wrongURL):
                                    sender.isEnabled = false
                                    completion(.failure(NetworkingError.wrongURL))
                                case .failure(NetworkingError.invalidURL):
                                    sender.isEnabled = false
                                    completion(.failure(NetworkingError.invalidURL))
                                case .failure(NetworkingError.invalidData):
                                    sender.isEnabled = false
                                    completion(.failure(NetworkingError.invalidData))
                                case .failure(NetworkingError.invalidDecodedData):
                                    completion(.failure(NetworkingError.invalidDecodedData))
                                case .failure(.invalidCategories):
                                    sender.isEnabled = false
                                    completion(.failure(NetworkingError.invalidCategories))
                                case .failure(NetworkingError.invalidDrinks):
                                    sender.isEnabled = false
                                    completion(.failure(NetworkingError.invalidDrinks))
                                case .failure(NetworkingError.invalidFirstCategory):
                                    sender.isEnabled = false
                                    completion(.failure(NetworkingError.invalidFirstCategory))
                                case .failure(NetworkingError.noMoreCocktails):
                                    sender.isEnabled = false
                                    completion(.failure(NetworkingError.noMoreCocktails))
                                case .success(let drinks):
                                    let newCategory = CocktailsByCategory(category: nextCategory, cocktails: drinks)
    
                                    completion(.success(newCategory))
    
                                    self.cocktailsByCategory.append(newCategory)
                                    print(nextCategory.name, drinks.count)
                                    drinks.forEach { drink in
                                        if let drinkName  = drink.name{
                                            print(".....\(drinkName)")
                                        }
    
                                    }
                            }
                        })
                    } else {
                        sender.isEnabled = false
                        completion(.failure(NetworkingError.noMoreCocktails))
                    }
                }
    
}
