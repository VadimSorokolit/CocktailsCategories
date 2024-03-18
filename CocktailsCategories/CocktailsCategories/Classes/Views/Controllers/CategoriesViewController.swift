//
//  CategoriesViewController.swift
//  CocktailsCategories
//
//  Created by Vadim on 14.03.2024.
//

import UIKit

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var viewModel: CocktailsViewModel!
    
    convenience init(viewModel: CocktailsViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }  
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FilterCell.self, forCellReuseIdentifier: FilterCell.reuseID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
//        tableView.backgroundColor = .beige
//        tableView.separatorStyle = .none
     
        return tableView
    }()
    
    private lazy var applyFiltersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply Filters", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
        super.viewDidLayoutSubviews()
        tableView.separatorColor = .black
//        tableView.backgroundColor = .red
        self.view.addSubview(tableView)
        self.view.addSubview(applyFiltersButton)
        self.setupLayout()
    }
    
    private func setupNavBar() {
        navigationItem.title = NSLocalizedString("Filters", comment: "")
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupLayout() {
        self.applyFiltersButton.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: self.applyFiltersButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 32.0)
        let rightConstraint = NSLayoutConstraint(item: self.applyFiltersButton, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -32.0)
        let bottomConstraint = NSLayoutConstraint(item: self.applyFiltersButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: -5.0)
        bottomConstraint.isActive = true
        let heightConstraint = self.applyFiltersButton.heightAnchor.constraint(equalToConstant: 50) 
        heightConstraint.isActive = true
        view.addConstraint(leftConstraint)
        view.addConstraint(rightConstraint)
        view.addConstraint(bottomConstraint)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 6
  
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilterCell.reuseID, for: indexPath)
//        let view = UIView()
//        view.backgroundColor = .gray
//        cell.selectedBackgroundView = view
//        cell.backgroundColor = .blue
//        let category = viewModel.loadedCategories[indexPath.row]
//        cell.configureCell(with: category.category.name)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
}
