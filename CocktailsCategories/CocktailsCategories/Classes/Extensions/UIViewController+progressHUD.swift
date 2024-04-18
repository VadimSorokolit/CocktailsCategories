//
//  UIViewController+progressHUD.swift
//  CocktailsCategories
//
import UIKit
import MBProgressHUD

extension UIViewController {
    
    func showHUD(_ message: String = "") {
        guard let navigationController = self.navigationController else {
            return
        }
        
        // Create a semi-transparent overlay view
        let overlayView = UIView(frame: navigationController.view.bounds)
        overlayView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        overlayView.tag = 999 // Assign a tag to identify the overlay view
        
        // Add the overlay view to the navigation controller's view
        navigationController.view.addSubview(overlayView)
        
        // Show MBProgressHUD on top of the overlay
        let progressHUD = MBProgressHUD.showAdded(to: navigationController.view, animated: false)
        progressHUD.isUserInteractionEnabled = true
        progressHUD.label.text = message
    }
    
    func hideHUD() {
        guard let navigationController = self.navigationController else {
            return
        }
        
        // Find and remove the overlay view by its tag
        if let overlayView = navigationController.view.viewWithTag(999) {
            overlayView.removeFromSuperview()
        }
        
        // Hide MBProgressHUD
        MBProgressHUD.hide(for: navigationController.view, animated: true)
    }
    
}
