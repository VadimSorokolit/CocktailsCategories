//
//  CocktailCell.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 03.04.2024.
//

import UIKit

class CocktailCell: UITableViewCell {
    
    // MARK: Objects
    
    private struct LocalConstants {
        static let reuseIDName: String = "CocktailCell"
    }
    
    // Mark: Properties
    
    static let reuseID = LocalConstants.reuseIDName
    
    let cocktailLabel: UILabel = {
        let label = UILabel()
        label.font = GlobalConstants.cocktailCellFont
        return label
    }()
    
    let cocktailImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError(GlobalConstants.fatalError)
    }
    
    // MARK: Methods
    
    private func setup() {
        self.setupViews()
        self.setupLayout()
    }
    
    private func setupViews() {
        self.contentView.addSubview(self.cocktailLabel)
        self.contentView.addSubview(self.cocktailImageView)
    }
    
    private func setupLayout() {
        let contentView = self.contentView
        let cocktailLabel = self.cocktailLabel
        let cocktailImageView = self.cocktailImageView
        
        NSLayoutConstraint.activate([
            cocktailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cocktailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -GlobalConstants.defaultPadding * 2),
            cocktailImageView.widthAnchor.constraint(equalToConstant: 60.0),
            cocktailImageView.heightAnchor.constraint(equalToConstant: 60.0),
            
            cocktailLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            cocktailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cocktailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cocktailLabel.leadingAnchor.constraint(equalTo: cocktailImageView.trailingAnchor, constant: -20),
        ])
    }

        func setupCell(with cocktail: CocktailsSection) {
            cocktailLabel.text = cocktail.category.name
            separatorInset.left = GlobalConstants.defaultPadding * 2
        }
    
}