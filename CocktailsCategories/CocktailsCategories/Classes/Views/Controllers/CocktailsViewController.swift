//
//  CocktailsViewController.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 21.02.2024.
//

import UIKit

class CocktailsViewController: UIViewController {
    
    // MARK: Objects
    
    private struct LocalConstants {
        static let badgeSideSize: CGFloat = 10.0
        static let textLabelHeightAnchor: CGFloat = 20.0
    }
    
    // MARK: Properties
    
    private let cocktailsViewModel: CocktailsViewModel
    private let alertsManager = AlertsManager()
    
    private lazy var navBarBadge: UIView = {
        let badge = UIView()
        badge.frame = CGRect(x: 17.0, y: -4.0, width: LocalConstants.badgeSideSize, height: LocalConstants.badgeSideSize)
        badge.backgroundColor = GlobalConstants.badgeColor
        badge.isHidden = true
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    // MARK: Initializer
    
    required init(cocktailsViewModel: CocktailsViewModel) {
        self.cocktailsViewModel = cocktailsViewModel
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let isBadgeShown = self.cocktailsViewModel.isBadgeShown
        self.navBarBadge.isHidden = !isBadgeShown
        self.reloadAndScrollToTop()
    }
    
    // MARK: Methods
    
    private func setup() {
        self.setupNavBar()
        self.setupViews()
        self.setupLayout()
        self.setObserver()
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
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setObserver() {
        self.cocktailsViewModel.completion = { (result: Result<Void, NetworkingError>) -> Void in
            DispatchQueue.main.async {
                switch result {
                    case .success:
                        self.tableView.reloadData()
                    case .failure(NetworkingError.noMoreCocktails):
                        self.alertsManager.showErrorAlert(error: NetworkingError.noMoreCocktails, in: self)
                        self.tableView.reloadData()
                    default:
                        self.alertsManager.showErrorAlert(error: NetworkingError.unknownError, in: self)
                        self.tableView.reloadData()
                }
            }
        }
    }
    
    func reloadAndScrollToTop() {
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.contentOffset = CGPoint(x: 0, y: -GlobalConstants.rowHeight)
    }
    
    private func loadFirstCategory() {
        self.cocktailsViewModel.loadFirstCategory()
    }
    
    private func loadNextCagegory() {
        self.cocktailsViewModel.loadNextCategory()
    }

    // MARK: Events
    
    @objc private func goToFiltersVC() {
        let filtersVC = FiltersViewController(viewModel: self.cocktailsViewModel)
        self.navigationController?.pushViewController(filtersVC, animated: true)
    }
    
}

// MARK: - table view delegate

extension CocktailsViewController: UITableViewDelegate {
    
    private func setupSectionHeaderView(for section: Int) -> UIView {
        let headerView = UIView()
        headerView.frame = CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: GlobalConstants.headerViewHeight)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GlobalConstants.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return GlobalConstants.headerViewHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.setupSectionHeaderView(for: section)
    }
    
    // Only for test !!!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.loadNextCagegory()
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
        let categoryCocktail = category.cocktails[indexPath.row]
        cell.setupCell(with: categoryCocktail)
        cell.separatorInset.left = GlobalConstants.defaultPadding * 2
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSections = self.cocktailsViewModel.filteredCategories.count
        return numberOfSections
    }
    
}






