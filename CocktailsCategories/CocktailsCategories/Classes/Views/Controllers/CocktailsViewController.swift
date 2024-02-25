//
//  ViewController.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 21.02.2024.
//

import UIKit

class CocktailsViewController: UIViewController {
    
    let cocktailsViewModel = CocktailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .yellow
        self.title = "Good !!!"
        self.myButton()
    }
    
    // MARK: Methods
    
    private func myButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 160, height: 60))
        button.center = view.center
        button.backgroundColor = .red
        button.layer.cornerRadius = 12
        button.setTitle("First button", for: .normal)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(myButtonDidTap), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc private func myButtonDidTap(_ sender: UIButton) {
        sender.showAnimation {
            self.cocktailsViewModel.getCoctailsCategory()
        }
        
    }
    
}

public extension UIView {
    func showAnimation(_ completionBlock: @escaping () -> Void) {
      isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
                            self?.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
        }) {  (done) in
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [weak self] in
                                self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) { [weak self] (_) in
                self?.isUserInteractionEnabled = true
                completionBlock()
            }
        }
    }
}

