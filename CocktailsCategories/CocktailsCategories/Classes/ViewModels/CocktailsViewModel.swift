//
//  File.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 22.02.2024.
//

import Foundation
import Moya

enum NetworkingError: LocalizedError {
//    case invalidURL
    case invalidDecoding
    case invalidData
//    case responseError
    case emptyFirstCategory
    case noMoreCocktails
    case error(Error)
    
    var errorDescription: String? {
        switch self {
//            case .invalidURL:
//                return NSLocalizedString("Invalid URL", comment: "NetworkingError - invalidURL")
            case .invalidDecoding:
                return NSLocalizedString("Invalid decoding", comment: "NetworkingError - invalidDecoding")
            case .invalidData:
                return NSLocalizedString("Invalid data", comment: "NetworkingError - invalidData")
//            case .responseError:
//                return NSLocalizedString("Response error", comment: "NetworkingError - responseError")
            case .emptyFirstCategory:
                return NSLocalizedString("Empty first category", comment: "NetworkingError - emptyFirstCategory")
            case .noMoreCocktails:
                return NSLocalizedString("No more cocktails", comment: "NetworkingError - noMoreCocktails")
            case .error(let error):
                return NSLocalizedString(error.localizedDescription, comment: "NetworkingError - error")
        }
    }
}

struct CocktailsSection: Equatable {

    let category: Category
    let cocktails: [Cocktail]
    var isSelected: Bool = false
    
    static func == (lhs: CocktailsSection, rhs: CocktailsSection) -> Bool {
        return lhs.category == rhs.category
    }
    
}

class CocktailsViewModel {
    
    // MARK: - Properties
    
    private let provider = MoyaProvider<CocktailsCategories>()
    private var allCategories: [Category] = []
    private var tempCategories: [CocktailsSection] = []
    private var savedCategories: [CocktailsSection] = []
    var loadedCategories: [CocktailsSection] = []
    var filteredCategories: [CocktailsSection] = []
    
    var completion: ((Result<Void, NetworkingError>) -> Void)? = nil
    
    var isLoadingData: Bool = false
    var noMoreCocktails: Bool = false
    
    var isEnableApplyFiltersButton: Bool {
        var counter = 0
        for category in self.filteredCategories {
            if self.savedCategories.contains(category) {
                counter += 1
            }
        }
        if self.filteredCategories.count != counter {
            return true
        } else {
            if self.filteredCategories == self.savedCategories {
                return false
            } else {
                return true
            }
        }
    }
    
    var hasFilters: Bool {
        let selectedCategoies = self.loadedCategories.filter({ $0.isSelected })
        let hasFilters = !selectedCategoies.isEmpty
        return hasFilters
    }
    
    // MARK: - Methods
    
    // MARK: - JSON Decoder
    
    private func getDecodedType<T: Decodable>(from data: Data) -> T? {
        do {
            let decodedGeneric = try JSONDecoder().decode(T.self, from: data)
            return decodedGeneric
        } catch {
            let error = error
            return error as? T
        }
    }
    
    // Get all categories
    func getAllCategories(completion: @escaping (Result<[Category], NetworkingError>) -> Void) {
        provider.request(.getAllCategories) { result in
            switch result {
            case .success(let moyaResponse):
                do {
                    let categoriesWrapper = try JSONDecoder().decode(CocktailsCategoriesWrapper.self, from: moyaResponse.data)
                    if let categories = categoriesWrapper.drinks {
                        self.allCategories = categories
                        completion(.success(categories))
                    } else {
                        completion(.failure(NetworkingError.invalidData))
                    }
                } catch {
                    completion(.failure(NetworkingError.invalidDecoding))
                }
            case .failure(let error):
                completion(.failure(NetworkingError.error(error)))
            }
        }
    }
//    private func getAllCategories(completion: @escaping (Result<[Category], NetworkingError>) -> Void) {
//        var components = URLComponents()
//        components.scheme = "https"
//        components.host = "thecocktaildb.com"
//        components.path = "/api/json/v1/1/list.php"
//        components.queryItems = [
//            URLQueryItem(name: "c", value: "list")
//        ]
//        
//        guard let urlString = components.string else {
//            completion(.failure(NetworkingError.invalidURL))
//            return
//        }
//        guard let url = URL(string: urlString) else {
//            completion(.failure(NetworkingError.invalidURL))
//            return
//        }
//        URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
//            if let error {
//                completion(.failure(NetworkingError.error(error)))
//                return
//            }
//            if let response = (response as? HTTPURLResponse), (200...299).contains(response.statusCode) {
//                let responseString = String(format: "Success with status code: %d", response.statusCode)
//                print(responseString)
//            } else {
//                completion(.failure(NetworkingError.responseError))
//                return
//            }
//            guard let data = data else {
//                completion(.failure(NetworkingError.invalidData))
//                return
//            }
//            do {
//                let decodedData = try JSONDecoder().decode(CocktailsCategoriesWrapper.self, from: data)
//                guard let categories = decodedData.drinks else {
//                    completion(.failure(NetworkingError.invalidDecoding))
//                    return
//                }
//                completion(Result.success(categories))
//            } catch let error {
//                completion(Result.failure(NetworkingError.error(error)))
//            }
//        }).resume()
//    }
    
    // Get Cocktails List by Category
    func getCocktails(by categoryName: Category, completion: @escaping (Result<[Cocktail], Error>) -> Void) {
        provider.request(.filter(by: categoryName.name)) { result in
            switch result {
            case .success(let moyaResponse):
                    do {
                        let cocktailsWrapper = try JSONDecoder().decode(CocktailsListWrapper.self, from: moyaResponse.data)
                        if let cocktailsDrinks = cocktailsWrapper.drinks {
                            completion(.success(cocktailsDrinks))
                        }
                    } catch {
                    completion(.failure(NetworkingError.error(error)))
                }
            case .failure(let error):
                    completion(.failure(NetworkingError.error(error)))
            }
        }
    }
//    private func getCocktails(by categoryName: String, completion: @escaping (Result<[Cocktail], NetworkingError>) -> Void) {
//        var components = URLComponents()
//        components.scheme = "https"
//        components.host = "thecocktaildb.com"
//        components.path = "/api/json/v1/1/filter.php"
//        components.queryItems = [
//            URLQueryItem(name: "c", value: categoryName)
//        ]
//        
//        guard let urlString = components.string else {
//            completion(.failure(NetworkingError.invalidURL))
//            return
//        }
//        guard let url = URL(string: urlString) else {
//            completion(.failure(NetworkingError.invalidURL))
//            return
//        }
//        URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
//            if let error {
//                completion(Result.failure(NetworkingError.error(error)))
//                return
//            }
//            if let response = (response as? HTTPURLResponse), (200...299).contains(response.statusCode) {
//                let responseString = String(format: "Success with status code: %d", response.statusCode)
//                print(responseString)
//            } else {
//                completion(.failure(NetworkingError.responseError))
//                return
//            }
//            guard let data = data else {
//                completion(.failure(NetworkingError.invalidData))
//                return
//            }
//            do {
//                let decodedData = try JSONDecoder().decode(CocktailsListWrapper.self, from: data)
//                guard let drinks = decodedData.drinks else {
//                    completion(.failure(NetworkingError.invalidDecoding))
//                    return
//                }
//                completion(Result.success(drinks))
//            } catch let error {
//                completion(Result.failure(NetworkingError.error(error)))
//            }
//        }).resume()
//    }

    // Get first category
    func loadFirstCategory() {
        self.isLoadingData = true
        self.getAllCategories(completion: { (result: Result<[Category], NetworkingError>) -> Void in
            self.isLoadingData = false
            switch result {
                case .failure(let error):
                    self.completion?(.failure(error))
                case .success(let categories):
                    self.allCategories = categories
                    guard let firstCategory = self.allCategories.first else {
                        self.completion?(.failure(NetworkingError.emptyFirstCategory))
                        return
                    }
                    self.getCocktails(by: firstCategory, completion: { (result: Result<[Cocktail], Error>) -> Void in
                        switch result {
                            case .failure(let error):
                                self.completion?(.failure(NetworkingError.error(error)))
                            case .success(let drinks):
                                let newCategory = CocktailsSection(category: firstCategory, cocktails: drinks)
                                self.loadedCategories.append(newCategory)
                                self.filteredCategories.append(newCategory)
                                self.tempCategories.append(newCategory)
                                self.completion?(.success(()))
                        }
                    })
            }
        })
    }
    
    // Get next category
    func loadNextCategory() {
        let nextIndex = self.loadedCategories.count
        let isNextCategoryExist = self.allCategories.indices.contains(nextIndex)
        
        if isNextCategoryExist {
            self.isLoadingData = true
            let nextCategory = self.allCategories[nextIndex]
            self.getCocktails(by: nextCategory, completion: { (result: Result<[Cocktail], Error>) in
                self.isLoadingData = false
                switch result {
                    case .failure(let error):
                        self.completion?(.failure(NetworkingError.error(error)))
                    case .success(let drinks):
                        let newCategory = CocktailsSection(category: nextCategory, cocktails: drinks)
                        if !self.loadedCategories.contains(newCategory) {
                            self.loadedCategories.append(newCategory)
                            self.filteredCategories.append(newCategory)
                            self.tempCategories.append(newCategory)
                            self.completion?(.success(()))
                        }
                }
            })
        } else {
            self.noMoreCocktails = true
            self.completion?(.failure(NetworkingError.noMoreCocktails))
        }
    }
    
    // Filter categories
    func filterCagegories(by text: String, completion: ([Int]) -> Void) {
        let characterNumbers = Array(text)
        let numbers = characterNumbers.compactMap({ Int(String($0)) })
        let indices = Array(Set(numbers)).sorted()
        self.filteredCategories.removeAll()
        var notExistIndices: [Int] = []
        
        for index in indices {
            if self.loadedCategories.indices.contains(index) {
                let loadedCategory = self.loadedCategories[index]
                self.filteredCategories.append(loadedCategory)
            } else {
                notExistIndices.append(index)
            }
        }
        completion(notExistIndices)
    }
    
    // Update set selected category
    func updateSetSelectedCategory(by index: Int) {
        if self.loadedCategories.indices.contains(index) {
            self.loadedCategories[index].isSelected.toggle()
            self.setupFilters()
        }
    }
    
    // Reset filters
    func resetFilters() {
        if self.savedCategories.isEmpty {
            for section in self.loadedCategories {
                var tempSection = section
                tempSection.isSelected = false
                self.savedCategories.append(tempSection)
            }
            self.loadedCategories = self.savedCategories
            self.filteredCategories = self.tempCategories
            self.savedCategories.removeAll()
        } else {
            self.tempCategories.removeAll()
            for section in self.loadedCategories {
                var tempSection = section
                tempSection.isSelected = true
                if self.savedCategories.contains(tempSection) {
                    self.tempCategories.append(tempSection)
                } else {
                    tempSection.isSelected = false
                    self.tempCategories.append(tempSection)
                }
            }
            self.loadedCategories = self.tempCategories
            self.setupFilters()
        }
    }
    
    // Setup Filters
    func setupFilters() {
        self.filteredCategories = self.loadedCategories.filter({ $0.isSelected })
    }
    
    // Apply filters
    func applyFilters() {
        self.savedCategories = self.loadedCategories.filter({ $0.isSelected })
        if self.savedCategories.isEmpty {
            self.filteredCategories = self.loadedCategories
            self.tempCategories = self.filteredCategories
        }
        self.completion?(.success(()))
    }
    
}
