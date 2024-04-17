//
//  AlertsManager.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 08.04.2024.
//

import Foundation
import UIKit

class AlertsManager {
    
    // MARK: Objects
    
    private struct LocalConstants {
        static let warningTitle = "Warning"
        static let errorTitle = "Error"
        static let okActionTitle = "Ok"
    }
    
    // MARK: Methods
    
    func showAlert(title: String, message: String, in viewContoller: UIViewController, okCompletion: ((UIAlertAction) -> (Void))?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalConstants.okActionTitle, style: UIAlertAction.Style.default, handler: okCompletion)
        alert.addAction(okAction)
        viewContoller.present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(error: Error, in viewController: UIViewController) {
        let errorDescriptionMessage = error.localizedDescription
        self.showAlert(title: LocalConstants.errorTitle, message: errorDescriptionMessage, in: viewController, okCompletion: nil)
    }
    
    func showWarningAlert(warning: Error, in viewController: UIViewController) {
        let warningDescriptionMessage = warning.localizedDescription
        self.showAlert(title: LocalConstants.warningTitle, message: warningDescriptionMessage, in: viewController, okCompletion: nil)
    }
}
