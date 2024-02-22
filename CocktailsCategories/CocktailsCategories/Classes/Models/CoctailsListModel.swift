//
//  File.swift
//  CocktailsCategories
//
//  Created by Vadim  on 22.02.2024.
//

import Foundation

struct CocktailsListWrapper: Decodable {
    var drinks: [CocktailInfo]?
}

struct CocktailInfo: Decodable {
    let name: String?
    let thumbLink: String?
    let idDrink: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "strDrink"
        case thumbLink = "strDrinkThumb"
        case idDrink
    }
}
