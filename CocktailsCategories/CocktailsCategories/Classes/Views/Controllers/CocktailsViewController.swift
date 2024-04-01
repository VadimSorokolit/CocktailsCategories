//
//  CocktailsViewController.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 21.02.2024.
//

import UIKit

class CocktailsViewController: UIViewController {
    
    private let cocktailsViewModel: CocktailsViewModel

    required init(cocktailsViewModel: CocktailsViewModel) {
        self.cocktailsViewModel = cocktailsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    private lazy var inputTextField: UITextField = {
//        let inputTextField = UITextField()
//        inputTextField.frame = CGRectMake(116.5, 200.0, 160.0, 60.0)
//        inputTextField.backgroundColor = .green
//        inputTextField.layer.cornerRadius = 12.0
//        inputTextField.textColor = .black
//        inputTextField.layer.masksToBounds = true
//        inputTextField.font = .boldSystemFont(ofSize: 17.0)
//        inputTextField.placeholder = "Input categories to show"
//        inputTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20, height: 40))
//        inputTextField.leftViewMode = .always
//        return inputTextField
//    }()
    
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
    
//    private lazy var applyButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.frame = CGRect(x: 116.5, y: 600.0, width: 160.0, height: 60.0)
//        button.backgroundColor = .red
//        button.layer.cornerRadius = 12.0
//        button.tintColor = .white
//        button.layer.masksToBounds = true
//        button.setTitle("Apply filter", for: .normal)
//        button.addTarget(self, action: #selector(self.applyButtonDidTap), for: .touchUpInside)
//        return button
//    }()
    
    // Load first cocktails on Start!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavBar()
        self.setupViews()
        self.loadFirstCategory()
        self.setupFiltersBarButton()
    }
    
    // MARK: Methods
    
    private func setupViews() {
        self.view.backgroundColor = GlobalConstants.backgroundColor

//        self.view.addSubview(self.inputTextField)
        self.view.addSubview(self.loadNextButton)
//        self.view.addSubview(self.applyButton)
    }
    
    private func setupNavBar() {
        self.navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = NSLocalizedString("Drinks", comment: "")
        self.navigationController?.navigationBar.tintColor = GlobalConstants.navigationBarTintColor
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.shadowImage = UIImage()
        appearance.shadowColor = GlobalConstants.navigationBarColor
        appearance.backgroundColor = GlobalConstants.navigationBarColor
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupFiltersBarButton() {
        let badgeSideSize: CGFloat = 10.0
        
        let badge = UIView(frame: CGRect(x: 17.0, y: -4.0, width: badgeSideSize, height: badgeSideSize))
        badge.backgroundColor = .red
        badge.clipsToBounds = true
        badge.isHidden = false
        badge.layer.cornerRadius = badgeSideSize / 2
        
        let button = UIButton()
        button.tintColor = .red
        button.setImage(UIImage(named: "filter_icon"), for: .normal)
        button.addTarget(self, action: #selector(goToFiltersVC), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
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
    
//    private func filterCagegories() {
//        guard let text = self.inputTextField.text, Int(text) != nil else {
//            print("Please input number")
//            return
//        }
        
//        self.cocktailsViewModel.filterCagegories(by: text, completion: { (notExistIndices: [Int]) -> Void in
//            if !notExistIndices.isEmpty {
//                print("Wasn't load categories by indices: \(notExistIndices)")
//            }
//            let categories = self.cocktailsViewModel.filteredCategories
//            self.printCategories(categories)
//        })
//    }
//    
    @objc private func loadNextButtonDidTap(withSender sender: UIButton) {

        sender.isEnabled = false
        self.loadNextCagegory(completion: { () -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                sender.isEnabled = true
            })
        })
    }
//    
//    @objc private func applyButtonDidTap(_ textField: UITextField) {
//        self.goToFiltersVC()
//        self.filterCagegories()
//    }
    
}

// MARK: - table view delegate

//extension CocktailsViewController: UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let brewery = viewModel.loadedCategories[indexPath.row]
//        let detailsVC = CategoriesViewController(model: brewery)
//        navigationController?.pushViewController(detailsVC, animated: true)
//    }
//}

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

