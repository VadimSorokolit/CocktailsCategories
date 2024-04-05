//
//  CocktailCell.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 03.04.2024.
//

import UIKit
import SDWebImage

class CocktailCell: UITableViewCell {
    
    // MARK: Objects
    
    private struct LocalConstants {
        static let reuseIDName: String = "CocktailCell"
    }
    
    // Mark: Properties
    
    static let reuseID = LocalConstants.reuseIDName
    
    
    private lazy var cocktailLabel: UILabel = {
        let label = UILabel()
        label.font = GlobalConstants.cocktailCellFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cocktailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
    
    func setupCell(with cocktail: Cocktail ) {
        cocktailImageView.sd_setImage(with: URL(string: cocktail.thumbLink ?? ""), placeholderImage: UIImage(named: "placeholder"))
        cocktailLabel.text = cocktail.name
        separatorInset.left = GlobalConstants.defaultPadding * 2
    }
    
}
