//
//  CocktailCell.swift
//  CocktailsCategories
//
//  Created by Vadym Sorokolit on 03.04.2024.
//

import UIKit
import SnapKit
import SDWebImage

class CocktailCell: UITableViewCell {
    
    // MARK: - Objects
    
    private struct LocalConstants {
        static let reuseIDName: String = "CocktailCell"
        static let cocktailImageViewWidth: CGFloat = 60.0
        static let cocktailLabelWidth: CGFloat = 20.0
    }
    
    // MARK: - Properties
    
    static let reuseID = LocalConstants.reuseIDName
    
    private lazy var cocktailLabel: UILabel = {
        let label = UILabel()
        label.font = GlobalConstants.cocktailCellFont
        return label
    }()
    
    private lazy var cocktailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = GlobalConstants.defaultPadding / 2
        imageView.clipsToBounds = true
        return imageView
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
        self.contentView.addSubview(self.cocktailLabel)
        self.contentView.addSubview(self.cocktailImageView)
    }
    
    private func setupLayout() {
        
        self.cocktailImageView.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.leading.equalTo(self.contentView.snp.leading).offset(GlobalConstants.defaultPadding * 2)
            make.width.height.equalTo(LocalConstants.cocktailImageViewWidth)
        }
        
        self.cocktailLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.contentView.snp.top)
            make.leading.equalTo(self.cocktailImageView.snp.trailing).offset(LocalConstants.cocktailLabelWidth)
            make.trailing.equalTo(self.contentView.snp.trailing)
            make.bottom.equalTo(self.contentView.snp.bottom)
        }
        
    }
    
    func setupCell(with cocktail: Cocktail) {
        let url = URL(string: cocktail.thumbLink ?? "")
        let placeholder = UIImage(named: "placeholder")
        
        self.cocktailImageView.sd_setImage(with: url, placeholderImage: placeholder )
        let cocktailName = cocktail.name
        self.cocktailLabel.text = cocktailName
    }
    
}
