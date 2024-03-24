//
//  GlobalConstans.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 20.03.2024.
//

import UIKit

struct Constants {
    
    static let cocktailCellFont: UIFont? = UIFont(name: "AvenirNext-DemiBold", size: 16.0) ?? UIFont(name: "SF Compact", size: 16.0)
    static let titleLabelFont = UIFont.systemFont(ofSize: 16.0, weight: .bold)
    static let defaultPadding: CGFloat = 16.0
    static let heightForRowAt: CGFloat = 50.0
    static let labelLeadingAnchor: CGFloat = 20.0
    static let buttonCornerRadius: CGFloat = 10.0
    static let buttonBorderWidth: CGFloat = 1.0
    static let buttonHeightAnchor: CGFloat = 50
    static let buttonDefaultAnchor: CGFloat = 32
    static let viewDefaultAnchor: CGFloat = 0
    static let safeAreaDefaultAnchor: CGFloat = 0
    static let imageName: String = "circle"
    static let reuseIDName: String = "FilterCell"
    static let fatalError: String = "init(coder:) has not been implemented"
    static let applyFiltersButtonName: String = "Apply Filters"
    
}
