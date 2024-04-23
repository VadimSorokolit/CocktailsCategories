//
//  File.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 22.02.2024.
//

import Foundation
import Moya

enum NetworkingError: LocalizedError {
    case invalidDecoding
    case invalidData
    case invalidFirstCategory
    case noMoreCocktails
    case error(Error)
    
    var errorDescription: String? {
        switch self {
            case .invalidDecoding:
                return NSLocalizedString("Invalid decoding", comment: "NetworkingError - invalidDecoding")
            case .invalidData:
                return NSLocalizedString("Invalid data", comment: "NetworkingError - invalidData")
            case .invalidFirstCategory:
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
    
    private let provider = MoyaProvider<CocktailsService>()
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

    // Get all categories
    func getAllCategories(completion: @escaping (Result<[Category], NetworkingError>) -> Void) {
        self.provider.request(.getAllCategories, completion: { (result: Result<Response, MoyaError>) -> Void in
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
        })
    }

    // Get Cocktails List by Category
    func getCocktails(by category: Category, completion: @escaping (Result<[Cocktail], Error>) -> Void) {
        self.provider.request(.filter(by: category.name), completion: { (result: Result<Response, MoyaError>) -> Void in
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
        })
    }

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
                        self.completion?(.failure(NetworkingError.invalidFirstCategory))
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
