//
//  CocktailsViewController.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 21.02.2024.
//

import UIKit
import SnapKit
import MBProgressHUD
import SDWebImage

class CocktailsViewController: UIViewController {
    
    // MARK: - Objects
    
    private struct LocalConstants {
        static let badgeSideSize: CGFloat = 10.0
        static let textLabelHeightAnchor: CGFloat = 20.0
        static let spinnerHeight: CGFloat = 60.0
        static let viewDefaultAnchor: CGFloat = 0.0
    }
    
    // MARK: - Properties
    
    private let cocktailsViewModel: CocktailsViewModel
    private let alertsManager = AlertsManager()
    
    private lazy var navBarBadge: UIView = {
        let badge = UIView()
        badge.frame = CGRect(x: 17.0, y: -4.0, width: LocalConstants.badgeSideSize, height: LocalConstants.badgeSideSize)
        badge.backgroundColor = GlobalConstants.badgeColor
        badge.layer.cornerRadius = LocalConstants.badgeSideSize / 2
        return badge
    }()
    
    private lazy var navBarFilterButton: UIButton = {
        let button = UIButton()
        button.addSubview(self.navBarBadge)
        button.setImage(UIImage(named: "filter_icon"), for: .normal)
        button.addTarget(self, action: #selector(self.goToFiltersVC), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CocktailCell.self, forCellReuseIdentifier: CocktailCell.reuseID)
        tableView.backgroundColor = GlobalConstants.defaultBackgroundColor
        tableView.sectionHeaderTopPadding = .zero
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var footerSpinner: UIActivityIndicatorView = {
        let spinnerView = UIActivityIndicatorView()
        spinnerView.hidesWhenStopped = true
        let spinnerWidth = self.tableView.bounds.width
        spinnerView.frame = CGRect(x: 0.0, y: 0.0, width: spinnerWidth, height: LocalConstants.spinnerHeight)
        return spinnerView
    }()

    // MARK: - Initializer
    
    required init(cocktailsViewModel: CocktailsViewModel) {
        self.cocktailsViewModel = cocktailsViewModel
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let hasFilters = self.cocktailsViewModel.hasFilters
        self.navBarBadge.isHidden = !hasFilters
        self.reloadAndScrollToTop()
    }
    
    // MARK: - Methods
    
    private func setup() {
        self.setupNavBar()
        self.setupViews()
        self.setupLayout()
        self.setObservers()
        self.loadFirstCategory()
    }
    
    private func setupViews() {
        self.view.backgroundColor = GlobalConstants.defaultBackgroundColor
        self.view.addSubview(self.tableView)
    }
    
    private func setupNavBar() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = NSLocalizedString("Drinks", comment: "")
        self.navigationController?.navigationBar.tintColor = GlobalConstants.navigationBarTintColor
        
        let barButton = UIBarButtonItem(customView: self.navBarFilterButton)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    private func setupLayout() {
        
        self.tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp.top)
            make.leading.trailing.equalTo(self.view).inset(LocalConstants.viewDefaultAnchor)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
    private func setObservers() {
        self.cocktailsViewModel.completion = { (result: Result<Void, NetworkingError>) -> Void in
            DispatchQueue.main.async {
                self.stopFooterSpinner()
                self.hideHUD()
                switch result {
                    case .success:
                        self.tableView.reloadData()
                    case .failure(.error(let systemError)):
                        self.showAlert(withError: systemError)
                    case .failure(let customError):
                        self.showAlert(withWarning: customError)
                }
            }
        }
    }
    
    private func reloadAndScrollToTop() {
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        self.tableView.contentOffset = CGPoint(x: 0.0, y: -GlobalConstants.rowHeight)
    }
    
    private func startFooterSpinner() {
        self.tableView.tableFooterView = self.footerSpinner
        self.footerSpinner.startAnimating()
    }
    
    private func stopFooterSpinner() {
        self.tableView.tableFooterView = nil
        self.footerSpinner.stopAnimating()
    }
    
    private func showAlert(withError error: Error) {
        self.alertsManager.showErrorAlert(error: error, in: self)
    }
    
    private func showAlert(withWarning error: NetworkingError) {
        self.alertsManager.showWarningAlert(warning: error, in: self)
    }
    
    private func loadFirstCategory() {
        self.showHUD()
        self.cocktailsViewModel.loadFirstCategory()
    }
    
    private func loadNextCategory() {
        self.cocktailsViewModel.loadNextCategory()
    }
    
    private func getMoreCocktailsPaginateIfNeeded(for indexPath: IndexPath) {
        let canPaginate = (indexPath == self.tableView.lastIndexPath)
                          && !self.cocktailsViewModel.isLoadingData
                          && !self.cocktailsViewModel.hasFilters
                          && !self.cocktailsViewModel.noMoreCocktails
        // Pagination
        if canPaginate {
            self.startFooterSpinner()
            self.loadNextCategory()
        }
    }

    // MARK: - Events
    
    @objc private func goToFiltersVC() {
        let filtersVC = FiltersViewController(viewModel: self.cocktailsViewModel)
        self.navigationController?.pushViewController(filtersVC, animated: true)
    }
    
}

// MARK: - UITableViewDelegate

extension CocktailsViewController: UITableViewDelegate {
    
    private func setupSectionHeaderView(for section: Int) -> UIView {
        let headerView = UIView()
        headerView.frame = CGRect(x: 0.0, y: 0.0, width: self.tableView.frame.width, height: GlobalConstants.headerViewHeight)
        headerView.backgroundColor = GlobalConstants.headerBackgroundColor
        
        let textLabel = UILabel()
        textLabel.font = GlobalConstants.headerTextFont
        textLabel.textColor = GlobalConstants.headerTextColor
        let categoryName = self.cocktailsViewModel.filteredCategories[section].category.name
        textLabel.text = categoryName.uppercased()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(textLabel)
        
        textLabel.heightAnchor.constraint(equalToConstant: LocalConstants.textLabelHeightAnchor).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: GlobalConstants.defaultPadding).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -GlobalConstants.defaultPadding).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        let separator = UIView()
        separator.backgroundColor = GlobalConstants.separatorColor
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(separator)
        
        separator.heightAnchor.constraint(equalToConstant: GlobalConstants.separatorHeight).isActive = true
        separator.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.getMoreCocktailsPaginateIfNeeded(for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GlobalConstants.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return GlobalConstants.headerViewHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.setupSectionHeaderView(for: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - UITableViewDataSource

extension CocktailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = self.cocktailsViewModel.filteredCategories[section]
        let cocktailsCount = category.cocktails.count
        return cocktailsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CocktailCell.reuseID, for: indexPath) as? CocktailCell else {
            return UITableViewCell()
        }
        
        let category = self.cocktailsViewModel.filteredCategories[indexPath.section]
        let cocktail = category.cocktails[indexPath.row]
        cell.setupCell(with: cocktail)
        cell.separatorInset.left = GlobalConstants.defaultPadding * 2
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSections = self.cocktailsViewModel.filteredCategories.count
        return numberOfSections
    }
    
}






