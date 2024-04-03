//
//  CocktailsViewController.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 21.02.2024.
//

import UIKit

class CocktailsViewController: UIViewController {
    
    // MARK: Properties
    
    private let cocktailsViewModel: CocktailsViewModel
    
    private lazy var loadNextButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 160.0, height: 60.0)
        button.center = self.view.center
        button.backgroundColor = .blue
        button.tintColor = .white
        button.layer.cornerRadius = 12.0
        button.layer.masksToBounds = true
        button.setTitle("Paginate cocktails", for: .normal)
        button.addTarget(self, action: #selector(self.loadNextButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var navBarBadgeButton: UIView = {
        let badgeSideSize: CGFloat = 10
        
        let badge = UIView()
        badge.frame = CGRect(x: 17, y: -4, width: badgeSideSize, height: badgeSideSize)
        badge.backgroundColor = GlobalConstants.badgeColor
        badge.isHidden = true
        badge.layer.cornerRadius = badgeSideSize / 2
        return badge
    }()
    
    private lazy var navBarButton: UIButton = {
        let button = UIButton()
        button.addSubview(self.navBarBadgeButton)
        button.setImage(UIImage(named: "filter_icon"), for: .normal)
        button.addTarget(self, action: #selector(goToFiltersVC), for: .touchUpInside)
        return button
    }()
    
    // Mark: Initializer
    
    required init(cocktailsViewModel: CocktailsViewModel) {
        self.cocktailsViewModel = cocktailsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let isBadgeShown = self.cocktailsViewModel.isBadgeShown
        self.navBarBadgeButton.isHidden = isBadgeShown
    }
    
    // MARK: Methods
    
    private func setup() {
        self.setupViews()
        self.setupNavBar()
        self.loadFirstCategory()
    }
    
    private func setupViews() {
        self.view.backgroundColor = GlobalConstants.backgroundColor
        self.view.addSubview(self.loadNextButton)
    }
    
    private func setupNavBar() {
        self.navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = NSLocalizedString("Drinks", comment: "")
        self.navigationController?.navigationBar.tintColor = GlobalConstants.navigationBarTintColor
        self.setupNavBarFiltersButton()
    }
    
    private func setupNavBarFiltersButton() {
        let barButton = UIBarButtonItem(customView: self.navBarButton)
        navigationItem.rightBarButtonItem = barButton
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

// MARK: - navigation controller

extension UINavigationController {
    
    func addCustomBottomLine(color: UIColor, height: Double) {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = color
        
        navigationBar.addSubview(lineView)
        
        NSLayoutConstraint.activate([
            lineView.widthAnchor.constraint(equalTo: navigationBar.widthAnchor),
            lineView.heightAnchor.constraint(equalToConstant: CGFloat(height)),
            lineView.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor),
            lineView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
        ])
    }
    
}

