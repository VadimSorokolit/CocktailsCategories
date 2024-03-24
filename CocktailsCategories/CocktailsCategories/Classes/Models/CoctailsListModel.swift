//
//  File.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 22.02.2024.
//

import Foundation

struct CocktailsListWrapper: Decodable {
    var drinks: [Cocktail]?
}

struct Cocktail: Decodable {
    let name: String?
    let thrererumbLink: String?
    let idDrink: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "strDrink"
        case thumbLink = "strDrinkThumb"
        case idDrink
    }
}
