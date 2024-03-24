//
//  CategoriesViewController.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 14.03.2024.
//

import UIKit

class FiltersViewController: UIViewController {
    
    private let viewModel: CocktailsViewModel
    
    required init(viewModel: CocktailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    private lazy var applyFiltersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.applyFiltersButtonName, for: .normal)
        button.titleLabel?.font = Constants.titleLabelFont
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.layer.masksToBounds = true
        button.layer.borderWidth = Constants.buttonBorderWidth
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FilterCell.self, forCellReuseIdentifier: FilterCell.reuseID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        self.setupNavBar()
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.applyFiltersButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupLayout()
    }
    
    private func setupNavBar() {
        self.navigationItem.title = NSLocalizedString("Filters", comment: "")
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    private func setupLayout() {
        self.applyFiltersButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: Constants.buttonDefaultAnchor).isActive = true
        self.applyFiltersButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -Constants.buttonDefaultAnchor).isActive = true
        self.applyFiltersButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeightAnchor).isActive = true
        self.applyFiltersButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.safeAreaDefaultAnchor).isActive = true
        
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: Constants.viewDefaultAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: Constants.viewDefaultAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: Constants.viewDefaultAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.applyFiltersButton.topAnchor).isActive = true
    }
}

// MARK: - UITableViewDelegate

extension FiltersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightForRowAt
    }
}

// MARK: - UITableViewDataSource

extension FiltersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let categoriesCount = self.viewModel.loadedCategories.count
        return categoriesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilterCell.reuseID, for: indexPath) as! FilterCell
        let category = self.viewModel.loadedCategories[indexPath.row]
        cell.configureCell(with: category)
        return cell
    }
    
}
    

