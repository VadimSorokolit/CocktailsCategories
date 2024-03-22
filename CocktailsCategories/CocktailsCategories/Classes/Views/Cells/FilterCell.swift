//
//  FilterCell.swift
//  CocktailsCategories
//
//  Created by Vadim on 17.03.2024.
//

import UIKit

class FilterCell: UITableViewCell {
    static let reuseID = "FilterCell"
    
    private lazy var checkMark: UIImageView = {
        let outputView = UIImageView()
        outputView.translatesAutoresizingMaskIntoConstraints = false
        outputView.image = UIImage(systemName: "checkmark")
        outputView.tintColor = .black
        return outputView
    }()
    
    private lazy var nameLabel: UILabel = {
        let outputLabel = UILabel()
        outputLabel.translatesAutoresizingMaskIntoConstraints = false
        outputLabel.numberOfLines = 1
        outputLabel.font = Constants.cocktailCellFont
        outputLabel.textColor = .black
        return outputLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.setupViews()
        self.setupLayout()
    }
    
    private func setupViews() {
        self.contentView.addSubview(self.checkMark)
        self.contentView.addSubview(self.nameLabel)
    }
    
    private func setupLayout() {
        let contentView = self.contentView
        let nameLabel = self.nameLabel
        let checkMark = self.checkMark
        
        NSLayoutConstraint.activate([
            checkMark.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkMark.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.defaultPadding),
            checkMark.widthAnchor.constraint(equalToConstant: Constants.defaultPadding),
            checkMark.heightAnchor.constraint(equalToConstant: Constants.defaultPadding),
            
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            nameLabel.trailingAnchor.constraint(equalTo: checkMark.leadingAnchor, constant: -Constants.defaultPadding),
        ])
    }
    
    func configureCell(with section: CocktailsSection) {
        self.nameLabel.text = section.category.name
    }
}


