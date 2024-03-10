//
//  File.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 22.02.2024.
//

import Foundation

enum NetworkingError: Error {
    case invalidURL
    case invalidDecoding
    case invalidData
    case emptyFirstCategory
    case noMoreCocktails
    case error(Error)
}

struct CocktailsByCategory {
    let category: Category
    let cocktails: [Cocktail]
}

class CocktailsViewModel {
    
    // MARK: - Properties
    
    private var allCategories: [Category] = []
    var loadedCategories: [CocktailsByCategory] = []
    var filteredCategories: [CocktailsByCategory] = []
    
    // MARK: - Methods
    
    // Get all categories
    private func getAllCategories(completion: @escaping (Result<[Category], NetworkingError>) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "thecocktaildb.com"
        components.path = "/api/json/v1/1/list.php"
        components.queryItems = [
            URLQueryItem(name: "c", value: "list")
        ]
        
        guard let urlString = components.string else {
            completion(.failure(NetworkingError.invalidURL))
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
                    completion(.failure(NetworkingError.invalidDecoding))
                    return
                }
                completion(Result.success(categories))
            } catch let error {
                completion(Result.failure(NetworkingError.error(error)))
            }
        }).resume()
    }
    
    // Get Cocktails List by Category
    private func getCocktails(by categoryName: String, completion: @escaping (Result<[Cocktail], NetworkingError>) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "thecocktaildb.com"
        components.path = "/api/json/v1/1/filter.php"
        components.queryItems = [
            URLQueryItem(name: "c", value: categoryName)
        ]
        
        guard let urlString = components.string else {
            completion(.failure(NetworkingError.invalidURL))
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
                    completion(.failure(NetworkingError.invalidDecoding))
                    return
                }
                completion(Result.success(drinks))
            } catch let error {
                completion(Result.failure(NetworkingError.error(error)))
            }
        }).resume()
    }
    
    // Get first category
    func loadFirstCategory(completion: @escaping (Result<CocktailsByCategory, NetworkingError>) -> Void) {
        self.getAllCategories(completion: { (result: Result<[Category], NetworkingError>) -> Void in
            switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let categories):
                    self.allCategories = categories
                    guard let firstCategory = self.allCategories.first else {
                        completion(.failure(NetworkingError.emptyFirstCategory))
                        return
                    }
                    self.getCocktails(by: firstCategory.name, completion: { (result: Result<[Cocktail], NetworkingError>) -> Void in
                        switch result {
                            case .failure(let error):
                                completion(.failure(error))
                            case .success(let drinks):
                                let newCategory = CocktailsByCategory(category: firstCategory, cocktails: drinks)
                                self.loadedCategories.append(newCategory)
                                self.filteredCategories.append(newCategory)
                                completion(.success(newCategory))
                        }
                    })
            }
        })
    }
    
    // Get next category
    func loadNextCategory(completion: @escaping (Result<CocktailsByCategory, NetworkingError>) -> Void) {
        let nextIndex = self.loadedCategories.count
        let isNextCategoryExist = self.allCategories.indices.contains(nextIndex)
        
        if isNextCategoryExist {
            let nextCategory = self.allCategories[nextIndex]
            self.getCocktails(by: nextCategory.name, completion: { (result: Result<[Cocktail], NetworkingError>) in
                switch result {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success(let drinks):
                        let newCategory = CocktailsByCategory(category: nextCategory, cocktails: drinks)
                        self.loadedCategories.append(newCategory)
                        self.filteredCategories.append(newCategory)
                        completion(.success(newCategory))
                }
            })
        } else {
            completion(.failure(NetworkingError.noMoreCocktails))
        }
    }
    
    // Get filtered categories
    func filterCagegoriesByIndices(byIndices indices: [Int], completion: ([Int]) -> Void) {
        self.filteredCategories.removeAll()
        var notExistedIndices: [Int] = []
        for index in indices {
            if self.loadedCategories.indices.contains(index) {
                let loadedCategory = self.loadedCategories[index]
                self.filteredCategories.append(loadedCategory)
            } else {
                notExistedIndices.append(index)
            }
        }
        completion(notExistedIndices)
    }
    
}
