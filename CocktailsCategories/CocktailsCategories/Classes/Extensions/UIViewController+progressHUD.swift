//
//  UIViewController+progressHUD.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 18.04.2024.
//

import MBProgressHUD

extension UIViewController {
    
    func hideHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func showHUD(_ message: String = "") {
        let progressHUD: MBProgressHUD
        progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = message
    }
    
}
