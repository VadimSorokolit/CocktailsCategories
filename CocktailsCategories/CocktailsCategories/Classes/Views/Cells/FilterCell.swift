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
        static let labelLeadingAnchor: CGFloat = 20.0
        static let badgeDefaultPadding: CGFloat = 12
        static let labelNumberOfLines: Int = 1
    }
    
    // Mark: Properties
    
    static let reuseID = LocalConstants.reuseIDName
    
//    private lazy var checkMark: UIImageView = {
//        let outputView = UIImageView()
//        outputView.translatesAutoresizingMaskIntoConstraints = false
//        outputView.image = UIImage(systemName: LocalConstants.imageName)
//        outputView.tintColor = .white
//        return outputView
//    }()
    
    private lazy var badge: UIView = {
        let badgeSideSizeView: CGFloat = LocalConstants.badgeDefaultPadding
        let badgeView = UIView()
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        badgeView.backgroundColor = GlobalConstants.badgeColor
        badgeView.clipsToBounds = true
        badgeView.layer.cornerRadius = badgeSideSizeView / 2
        return badgeView
    }()
    
    private lazy var nameLabel: UILabel = {
        let outputLabel = UILabel()
        outputLabel.translatesAutoresizingMaskIntoConstraints = false
        outputLabel.numberOfLines = LocalConstants.labelNumberOfLines
        outputLabel.font = GlobalConstants.cocktailCellFont
        outputLabel.textColor = GlobalConstants.textColor
        return outputLabel
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
//      self.contentView.addSubview(self.checkMark)
        self.contentView.addSubview(self.badge)
        self.contentView.addSubview(self.nameLabel)
    }
    
    private func setupLayout() {
        let contentView = self.contentView
        let nameLabel = self.nameLabel
        let badge = self.badge
        
        NSLayoutConstraint.activate([
            badge.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            badge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -GlobalConstants.defaultPadding),
            badge.widthAnchor.constraint(equalToConstant: LocalConstants.badgeDefaultPadding),
            badge.heightAnchor.constraint(equalToConstant: LocalConstants.badgeDefaultPadding),
//            checkMark.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            checkMark.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LocalConstants.defaultPadding),
//            checkMark.widthAnchor.constraint(equalToConstant: LocalConstants.defaultPadding),
//            checkMark.heightAnchor.constraint(equalToConstant: LocalConstants.defaultPadding),
            
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LocalConstants.labelLeadingAnchor),
//            nameLabel.trailingAnchor.constraint(equalTo: checkMark.leadingAnchor, constant: -LocalConstants.defaultPadding),
            nameLabel.trailingAnchor.constraint(equalTo: badge.leadingAnchor, constant: -GlobalConstants.defaultPadding),
        ])
    }
    
    func configureCell(with section: CocktailsSection) {
        self.nameLabel.text = section.category.name
//        self.checkMark.tintColor = section.isSelected ? .red : .black
        self.badge.isHidden = !section.isSelected
    }
    
}


