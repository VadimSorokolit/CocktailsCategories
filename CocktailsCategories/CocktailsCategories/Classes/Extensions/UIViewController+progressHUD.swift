//
//  UIViewController+progressHUD.swift
//  CocktailsCategories
//

import MBProgressHUD

extension UIViewController {
    
    func showHUD(_ message: String = "") {
        guard let navigationController = self.navigationController else { return }
        let progressHUD = MBProgressHUD.showAdded(to: navigationController.view, animated: true)
        progressHUD.backgroundColor = UIColor.lightText
        progressHUD.label.text = message
    }
    
    func hideHUD() {
        guard let navigationController = self.navigationController else { return }
        MBProgressHUD.hide(for: navigationController.view, animated: false)
    }
    
}
