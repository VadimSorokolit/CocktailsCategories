//
//  FilterCell.swift
//  CocktailsCategories
//
//  Created by Vadim  on 17.03.2024.
//

import UIKit

class FilterCell: UITableViewCell {
    static let reuseID = "FilterCell"
    
    private lazy var mainView: UIView = {
        let outputView = UIView()
        outputView.translatesAutoresizingMaskIntoConstraints = false
        outputView.backgroundColor = .white
        outputView.layer.cornerRadius = 8
        outputView.layer.masksToBounds = true
        return outputView
    }()
    
    private lazy var nameLabel: UILabel = {
        let outputLabel = UILabel()
        outputLabel.translatesAutoresizingMaskIntoConstraints = false
        outputLabel.numberOfLines = 0
        outputLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        outputLabel.textColor = .black
        return outputLabel
    }()
    
    private lazy var chevronImageView: UIImageView = {
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
        contentView.backgroundColor = .white
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.addSubview(mainView)
        mainView.addSubview(nameLabel)
        mainView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            nameLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            nameLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -16),
            
            chevronImageView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            chevronImageView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 16),
            chevronImageView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
            chevronImageView.widthAnchor.constraint(equalToConstant: 30),
            chevronImageView.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    func configureCell(with category: CocktailsByCategory) {
        nameLabel.text = category.category.name
    }
}
