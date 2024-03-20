//
//  FilterCell.swift
//  CocktailsCategories
//
//  Created by Vadim on 17.03.2024.
//

import UIKit

class FilterCell: UITableViewCell {
    static let reuseID = "FilterCell"
    
    private lazy var nameLabel: UILabel = {
        let outputLabel = UILabel()
        outputLabel.translatesAutoresizingMaskIntoConstraints = false
        outputLabel.numberOfLines = 0
        outputLabel.font = Constants.cocktailCellFont
        outputLabel.textColor = .black
        return outputLabel
    }()
    
    private lazy var checkMark: UIImageView = {
        let outputView = UIImageView()
        outputView.translatesAutoresizingMaskIntoConstraints = false
        outputView.image = UIImage(systemName: "checkmark")
        outputView.tintColor = .black
        return outputView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupViews()
        setupLayout()
    }
    
    private func setupViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(checkMark)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            checkMark.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkMark.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkMark.widthAnchor.constraint(equalToConstant: 20),
            checkMark.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    func configureCell(with category: CocktailsByCategory) {
        nameLabel.text = category.category.name
    }
}


