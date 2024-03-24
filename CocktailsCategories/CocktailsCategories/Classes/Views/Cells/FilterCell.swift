//
//  FilterCell.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 17.03.2024.
//

import UIKit

class FilterCell: UITableViewCell {
    
    // MARK: Objects
    
    private struct LocalConstants {
        static let imageName: String = "circle"
        static let reuseIDName: String = "FilterCell"
        static let defaultPadding: CGFloat = 16.0
        static let labelLeadingAnchor: CGFloat = 20.0
        static let labelNumberOfLines: Int = 1
    }
    
    static let reuseID = LocalConstants.reuseIDName
    
    private lazy var checkMark: UIImageView = {
        let outputView = UIImageView()
        outputView.translatesAutoresizingMaskIntoConstraints = false
        outputView.image = UIImage(systemName: LocalConstants.imageName)
        outputView.tintColor = .white
        return outputView
    }()
    
    private lazy var nameLabel: UILabel = {
        let outputLabel = UILabel()
        outputLabel.translatesAutoresizingMaskIntoConstraints = false
        outputLabel.numberOfLines = LocalConstants.labelNumberOfLines
        outputLabel.font = GlobalConstants.cocktailCellFont
        outputLabel.textColor = .black
        return outputLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError(GlobalConstants.fatalError)
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
            checkMark.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LocalConstants.defaultPadding),
            checkMark.widthAnchor.constraint(equalToConstant: LocalConstants.defaultPadding),
            checkMark.heightAnchor.constraint(equalToConstant: LocalConstants.defaultPadding),
            
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LocalConstants.labelLeadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: checkMark.leadingAnchor, constant: -LocalConstants.defaultPadding),
        ])
    }
    
    func configureCell(with section: CocktailsSection) {
        self.nameLabel.text = section.category.name
    }
    
}


