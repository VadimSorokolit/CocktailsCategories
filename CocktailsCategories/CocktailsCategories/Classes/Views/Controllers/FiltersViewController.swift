//
//  CategoriesViewController.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 14.03.2024.
//

import UIKit

class FiltersViewController: UIViewController {
    
    // MARK: Objects
    
    private struct LocalConstants {
        static let filterCellRowHigh: CGFloat = 50.0
        static let buttonCornerRadius: CGFloat = 10.0
        static let buttonBorderWidth: CGFloat = 1.0
        static let buttonHeightAnchor: CGFloat = 50.0
        static let buttonDefaultAnchor: CGFloat = 32.0
        static let viewDefaultAnchor: CGFloat = 0.0
        static let safeAreaDefaultAnchor: CGFloat = 0.0
        static let applyFiltersButtonName: String = "Apply Filters"
    }
    
    private let viewModel: CocktailsViewModel
    
    required init(viewModel: CocktailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(GlobalConstants.fatalError)
    }
    
    private lazy var applyFiltersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalConstants.applyFiltersButtonName, for: .normal)
        button.titleLabel?.font = GlobalConstants.titleLabelFont
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.backgroundColor = .white
        button.layer.cornerRadius = LocalConstants.buttonCornerRadius
        button.layer.masksToBounds = true
        button.layer.borderWidth = LocalConstants.buttonBorderWidth
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.addTarget(self, action: #selector(self.goTococktailsVC), for: .touchUpInside)
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
        
        self.view.backgroundColor = .white
        self.setupNavBar()
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.applyFiltersButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent {
            self.viewModel.resetFilters()
        }
    }
    
    private func setupNavBar() {
        self.navigationItem.title = NSLocalizedString("Filters", comment: "")
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupLayout() {
        self.applyFiltersButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: LocalConstants.buttonDefaultAnchor).isActive = true
        self.applyFiltersButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -LocalConstants.buttonDefaultAnchor).isActive = true
        self.applyFiltersButton.heightAnchor.constraint(equalToConstant: LocalConstants.buttonHeightAnchor).isActive = true
        self.applyFiltersButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: LocalConstants.safeAreaDefaultAnchor).isActive = true
        
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: LocalConstants.viewDefaultAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: LocalConstants.viewDefaultAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: LocalConstants.viewDefaultAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.applyFiltersButton.topAnchor).isActive = true
    }
    
    private func applyFiltersButtonOnOff() {
        if viewModel.filteredCategories.isEmpty {
            self.applyFiltersButton.isEnabled = false
        } else {
            self.applyFiltersButton.isEnabled = true
        }
    }
    
    @objc private func goTococktailsVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - UITableViewDelegate

extension FiltersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.setSelectedCategory(by: indexPath.row)
        self.tableView.reloadRows(at: [indexPath], with: .none)
        self.viewModel.applyFilters()
        self.applyFiltersButtonOnOff()
  
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LocalConstants.filterCellRowHigh
    }
}

// MARK: - UITableViewDataSource

extension FiltersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let categoriesCount = self.viewModel.loadedCategories.count
        return categoriesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterCell.reuseID, for: indexPath) as? FilterCell else {
            return UITableViewCell()
        }
        let category = self.viewModel.loadedCategories[indexPath.row]
        cell.configureCell(with: category)
        return cell
    }
    
}
    

