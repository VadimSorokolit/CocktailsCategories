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
        static let buttonCornerRadius: CGFloat = 10.0
        static let buttonBorderWidth: CGFloat = 2.0
        static let buttonHeightAnchor: CGFloat = 50.0
        static let buttonDefaultAnchor: CGFloat = 32.0
        static let viewDefaultAnchor: CGFloat = 0.0
        static let safeAreaDefaultAnchor: CGFloat = 16.0
        static let buttonName: String = "Apply Filters"
        static let buttonIsEnableTintColor: UIColor = UIColor(hexString: "000000")
        static let buttonIsDisableTintColor: UIColor = UIColor(hexString: "808080")
        static let buttonIsEnableBorderColor: UIColor = UIColor(hexString: "808080")
        static let buttonIsDisableBorderColor: UIColor = UIColor(hexString: "D3D3D3")
    }
    
    // MARK: Properties
        
    private let viewModel: CocktailsViewModel
    private var isApplyFiltersButtonPressed: Bool = false
    
    private lazy var applyFiltersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalConstants.buttonName, for: .normal)
        button.titleLabel?.font = GlobalConstants.titleLabelFont
        button.setTitleColor(LocalConstants.buttonIsEnableTintColor, for: .normal)
        button.setTitleColor(LocalConstants.buttonIsDisableTintColor, for: .disabled)
        button.backgroundColor = GlobalConstants.backgroundColor
        button.layer.borderColor = LocalConstants.buttonIsDisableBorderColor.cgColor
        button.layer.cornerRadius = LocalConstants.buttonCornerRadius
        button.layer.masksToBounds = true
        button.layer.borderWidth = LocalConstants.buttonBorderWidth
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.addTarget(self, action: #selector(self.onApplyFiltersButtonDidTap), for: .touchUpInside)
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
    
    // Mark: Initializer
    
    required init(viewModel: CocktailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(GlobalConstants.fatalError)
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !self.isApplyFiltersButtonPressed {
            self.viewModel.resetFilters()
        }
    }
    
    // MARK: Methods
    
    private func setup() {
        self.setupViews()
        self.setupNavBar()
        self.setupLayout()
    }
    
    private func setupViews() {
        self.view.backgroundColor = GlobalConstants.backgroundColor
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.applyFiltersButton)
    }
    
    private func setupNavBar() {
        self.navigationItem.title = NSLocalizedString("Filters", comment: "")
        self.navigationController?.navigationBar.tintColor = GlobalConstants.navigationBarTintColor
    }
    
    private func setupLayout() {
        self.applyFiltersButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: LocalConstants.buttonDefaultAnchor).isActive = true
        self.applyFiltersButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -LocalConstants.buttonDefaultAnchor).isActive = true
        self.applyFiltersButton.heightAnchor.constraint(equalToConstant: LocalConstants.buttonHeightAnchor).isActive = true
        self.applyFiltersButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -LocalConstants.safeAreaDefaultAnchor).isActive = true
        
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: LocalConstants.viewDefaultAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: LocalConstants.viewDefaultAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: LocalConstants.viewDefaultAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.applyFiltersButton.topAnchor).isActive = true
    }
    
    private func goToCocktailsViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupApplyFiltersButton() {
        self.applyFiltersButton.isEnabled = self.viewModel.isEnableApplyFiltersButton
        if self.applyFiltersButton.isEnabled {
            self.applyFiltersButton.layer.borderColor = LocalConstants.buttonIsEnableBorderColor.cgColor
        } else {
            self.applyFiltersButton.layer.borderColor  = LocalConstants.buttonIsDisableBorderColor.cgColor
        }
    }

    @objc private func onApplyFiltersButtonDidTap() {
        self.isApplyFiltersButtonPressed = true
        self.viewModel.applyFilters()
        self.goToCocktailsViewController()
    }
    
}

// MARK: - UITableViewDelegate

extension FiltersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.updateSetSelectedCategory(by: indexPath.row)
        self.tableView.reloadRows(at: [indexPath], with: .none)
        self.setupApplyFiltersButton()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GlobalConstants.filterCellRowHigh
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
        cell.selectionStyle = .none
        return cell
    }
    
}
    

