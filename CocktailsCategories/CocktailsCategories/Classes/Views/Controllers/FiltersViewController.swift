//
//  CategoriesViewController.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 14.03.2024.
//

import UIKit
import SnapKit

class FiltersViewController: UIViewController {
    
    // MARK: - Objects
    
    private struct LocalConstants {
        static let buttonCornerRadius: CGFloat = 10.0
        static let buttonBorderWidth: CGFloat = 2.0
        static let buttonHeightAnchor: CGFloat = 50.0
        static let buttonDefaultAnchor: CGFloat = 32.0
        static let viewDefaultAnchor: CGFloat = 0.0
        static let safeAreaDefaultAnchor: CGFloat = 16.0
        static let buttonName: String = "Apply Filters"
        static let buttonIsEnabledTintColor: UIColor = UIColor(hexString: "000000")
        static let buttonIsDisabledTintColor: UIColor = UIColor(hexString: "808080")
        static let buttonIsEnabledBorderColor: UIColor = UIColor(hexString: "808080")
        static let buttonIsDisabledBorderColor: UIColor = UIColor(hexString: "D3D3D3")
    }
    
    // MARK: - Properties
        
    private let viewModel: CocktailsViewModel
    private var isApplyFiltersButtonPressed: Bool = false
    
    private lazy var applyFiltersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalConstants.buttonName, for: .normal)
        button.titleLabel?.font = GlobalConstants.titleLabelFont
        button.setTitleColor(LocalConstants.buttonIsEnabledTintColor, for: .normal)
        button.setTitleColor(LocalConstants.buttonIsDisabledTintColor, for: .disabled)
        button.backgroundColor = GlobalConstants.defaultBackgroundColor
        button.layer.borderColor = LocalConstants.buttonIsDisabledBorderColor.cgColor
        button.layer.cornerRadius = LocalConstants.buttonCornerRadius
        button.layer.masksToBounds = true
        button.layer.borderWidth = LocalConstants.buttonBorderWidth
        button.isEnabled = false
        button.addTarget(self, action: #selector(self.onApplyFiltersButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FilterCell.self, forCellReuseIdentifier: FilterCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - Initializer
    
    required init(viewModel: CocktailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(GlobalConstants.fatalError)
    }
    
    // MARK: - Lifecycle
    
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
    
    // MARK: - Methods
    
    private func setup() {
        self.setupViews()
        self.setupNavBar()
        self.setupLayout()
    }
    
    private func setupViews() {
        self.view.backgroundColor = GlobalConstants.defaultBackgroundColor
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.applyFiltersButton)
    }
    
    private func setupNavBar() {
        self.navigationItem.title = NSLocalizedString("Filters", comment: "")
        self.navigationController?.navigationBar.tintColor = GlobalConstants.navigationBarTintColor
    }
    
    private func setupLayout() {
        
        self.applyFiltersButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(LocalConstants.buttonHeightAnchor)
            make.leading.trailing.equalTo(self.view).inset(LocalConstants.buttonDefaultAnchor)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-LocalConstants.safeAreaDefaultAnchor)
        }
        
        self.tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp.top).offset(LocalConstants.viewDefaultAnchor)
            make.leading.trailing.equalTo(self.view).inset(LocalConstants.viewDefaultAnchor)
            make.bottom.equalTo(self.applyFiltersButton.snp.top)
        }
        
    }
    
    private func goToCocktailsViewController() {
        self.navigationController?.popViewController(animated: true)
    }

    private func setupApplyFiltersButton() {
        self.applyFiltersButton.isEnabled = self.viewModel.isEnableApplyFiltersButton
        if self.applyFiltersButton.isEnabled {
            self.applyFiltersButton.layer.borderColor = LocalConstants.buttonIsEnabledBorderColor.cgColor
        } else {
            self.applyFiltersButton.layer.borderColor  = LocalConstants.buttonIsDisabledBorderColor.cgColor
        }
    }
    
    // MARK: - Events

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
    

