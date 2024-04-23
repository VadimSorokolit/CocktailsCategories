//
//  MoyaAPI.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 23.04.2024.
//

import Foundation
import Moya

enum CocktailsCategories {
    case getAllCategories
    case filter(by: String)
}

// MARK: - TargetType Protocol Implementation

extension CocktailsCategories: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1") else {
            fatalError("Invalid base URL")
        }
        return url
    }
    
    var path: String {
        switch self {
            case .getAllCategories:
                return "/list.php"
            case .filter:
                return "/filter.php"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .getAllCategories, .filter:
                return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Moya.Task {
        switch self {
            case .getAllCategories:
                return .requestParameters(parameters: ["c" : "list"], encoding: URLEncoding.default)
            case .filter(let categoryName):
                return .requestParameters(parameters: ["c" : "\(categoryName)"], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
