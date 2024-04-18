//
//  UITableView+lastIndexPath.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 15.04.2024.
//

import UIKit

extension UITableView {
    
    var lastIndexPath: IndexPath {
        let lastSection = max(numberOfSections - 1, 0)
        let lastRow = max(numberOfRows(inSection: lastSection) - 1, 0)
        return IndexPath(row: lastRow, section: lastSection)
    }
    
}

