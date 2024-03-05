//
//  CoctailsModel.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 22.02.2024.
//

import Foundation

struct CocktailsCategoriesWrapper: Decodable {
    var drinks: [Category]?
}

struct Category: Decodable, Hashable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "strCategory"
    }
}
