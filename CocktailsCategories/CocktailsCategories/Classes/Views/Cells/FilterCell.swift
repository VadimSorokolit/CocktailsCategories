//
//  FilterCell.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 17.03.2024.
//

import UIKit
import SnapKit

class FilterCell: UITableViewCell {
    
    // MARK: - Objects
    
    private struct LocalConstants {
        static let imageName: String = "circle"
        static let reuseIDName: String = "FilterCell"
        static let labelLeadingAnchor: CGFloat = 20.0
        static let badgeDefaultPadding: CGFloat = 12.0
        static let labelNumberOfLines: Int = 1
    }
    
    // MARK: - Properties
    
    static let reuseID = LocalConstants.reuseIDName
 
    private lazy var badge: UIView = {
        let badgeSideSizeView: CGFloat = LocalConstants.badgeDefaultPadding
        let badgeView = UIView()
        badgeView.backgroundColor = GlobalConstants.badgeColor
        badgeView.clipsToBounds = true
        badgeView.layer.cornerRadius = badgeSideSizeView / 2
        return badgeView
    }()
    
    private lazy var nameLabel: UILabel = {
        let outputLabel = UILabel()
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
    
    // MARK: - Methods
    
    private func setup() {
        self.setupViews()
        self.setupLayout()
    }
    
    private func setupViews() {
        self.contentView.addSubview(self.badge)
        self.contentView.addSubview(self.nameLabel)
    }
    
    private func setupLayout() {
        
        self.badge.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.trailing.equalTo(self.contentView.snp.trailing).offset(-GlobalConstants.defaultPadding)
            make.width.height.equalTo(LocalConstants.badgeDefaultPadding)
        }
        
        self.nameLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.leading.equalTo(self.contentView.snp.leading).offset(LocalConstants.labelLeadingAnchor)
            make.trailing.equalTo(self.badge.snp.leading).offset(-GlobalConstants.defaultPadding)
        }
        
    }
    
    func configureCell(with section: CocktailsSection) {
        self.nameLabel.text = section.category.name
        self.badge.isHidden = !section.isSelected
    }
    
}


