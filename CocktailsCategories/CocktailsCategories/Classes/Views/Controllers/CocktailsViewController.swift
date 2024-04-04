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
    }

    // MARK: Properties
    
    private let cocktailsViewModel: CocktailsViewModel
    
//    private lazy var loadNextButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.frame = CGRect(x: 0.0, y: 0.0, width: 160.0, height: 60.0)
//        button.center = self.view.center
//        button.backgroundColor = .blue
//        button.tintColor = .white
//        button.layer.cornerRadius = 12.0
//        button.layer.masksToBounds = true
//        button.setTitle("Paginate cocktails", for: .normal)
//        button.addTarget(self, action: #selector(self.loadNextButtonDidTap), for: .touchUpInside)
//        return button
//    }()
    
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
        tableView.register(FilterCell.self, forCellReuseIdentifier: FilterCell.reuseID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
//    private lazy var header: UIView = {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: cocktailsViewModel. , height: GlobalConstants.headerViewHeight))
//        headerView.backgroundColor = GlobalConstants.headerBackgroundColor
//        return header
//    }()
//    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.width, height: Constants.headerViewHeight))
//    headerView.backgroundColor = Constants.headerBgColor
    
    // Mark: Initializer
    
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
    }
    
    // MARK: Methods
    
    private func setup() {
        self.setupViews()
        self.setupNavBar()
        self.loadFirstCategory()
    }
    
    private func setupViews() {
        self.view.backgroundColor = GlobalConstants.backgroundColor
        // self.view.addSubview(self.loadNextButton)
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
        
    }
    
    @objc private func goToFiltersVC() {
        let filtersVC = FiltersViewController(viewModel: cocktailsViewModel)
        self.navigationController?.pushViewController(filtersVC, animated: true)
    }
    
    private func printCategories(_ categories: [CocktailsSection]) {
        for category in categories {
            let categoryName = category.category.name
            let cocktailsCount = category.cocktails.count
            let resultFormatedString = String(format: "CATEGORY: %@  COUNT OF COCKTAILS ARE: %d", arguments: [categoryName, cocktailsCount])
            print(resultFormatedString)
        }
    }
    
    private func loadFirstCategory() {
        self.cocktailsViewModel.loadFirstCategory(completion: { (result: Result<CocktailsSection, NetworkingError>) -> Void in
            switch result {
                case .success(let category):
                    print("----Loaded first category----")
                    self.printCategories([category])
                case .failure(NetworkingError.noMoreCocktails):
                    print(NetworkingError.noMoreCocktails)
                default:
                    print("Unknown Error")
            }
        })
    }
    
    private func loadNextCagegory(completion: @escaping () -> Void) {
        self.cocktailsViewModel.loadNextCategory(completion: { (result: Result<CocktailsSection, NetworkingError>) -> Void in
            switch result {
                case .success(let category):
                    print("----Loaded next category----")
                    self.printCategories([category])
                    completion()
                case .failure(NetworkingError.noMoreCocktails):
                    print(NetworkingError.noMoreCocktails)
                default:
                    print("Unknown Error")
            }
        })
    }
    
    @objc private func loadNextButtonDidTap(withSender sender: UIButton) {
        sender.isEnabled = false
        self.loadNextCagegory(completion: { () -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                sender.isEnabled = true
            })
        })
    }
    
}

// MARK: - table view delegate 

extension CocktailsViewController: UITableViewDelegate {
    
//    private func setupSectionHeaderView(for section: Int) -> UIView {
//        
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.width, height: GlobalConstants.headerViewHeight))
//        headerView.backgroundColor = GlobalConstants.headerBackgroundColor
//        
//        let textLabel = UILabel()
//        textLabel.font = GlobalConstants.headerTextFont
//        textLabel.textColor = GlobalConstants.headerTextColor
//        textLabel.text = "Hello Vadimon"
//        
//        headerView.addSubview(textLabel)
//        textLabel.snp.makeConstraints { make in
//            make.height.equalTo(20)
//            make.leading.trailing.equalToSuperview().inset(16)
//            make.centerY.equalToSuperview()
//        }
//        
//        let separator = UIView()
//        separator.backgroundColor = GlobalConstants.separatorColor
//        
//        headerView.addSubview(separator)
//        separator.snp.makeConstraints { make in
//            make.leading.trailing.bottom.equalTo(headerView)
//            make.height.equalTo(1)
//        }
//        return headerView
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return setupSectionHeaderView(for: section)
//    }
//    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return GlobalConstants.headerViewHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GlobalConstants.rowHeight
    }
    
}

// MARK: - UITableViewDataSource

extension CocktailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cocktailsViewModel.filteredCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CocktailCell.reuseID, for: indexPath) as? CocktailCell else {
            return UITableViewCell()
        }
        let category = self.cocktailsViewModel.filteredCategories[0]
            cell.setupCell(with: category)
        return cell

    }
    
}






