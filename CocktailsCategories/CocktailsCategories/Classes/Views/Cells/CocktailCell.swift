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
        static let cocktailImageViewDefaultAnchor: CGFloat = 60.0
        static let cocktailLabelDefaultAnchor: CGFloat = 20.0
    }
    
    // MARK: - Properties
    
    static let reuseID = LocalConstants.reuseIDName
    
    private lazy var cocktailLabel: UILabel = {
        let label = UILabel()
        label.font = GlobalConstants.cocktailCellFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cocktailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = GlobalConstants.defaultPadding / 2
        imageView.clipsToBounds = true
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
        
        self.cocktailImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.leading.equalTo(self.contentView.snp.leading).offset(GlobalConstants.defaultPadding * 2)
            make.width.height.equalTo(LocalConstants.cocktailImageViewDefaultAnchor)
        }
        
        self.cocktailLabel.snp.makeConstraints { make in
            make.top.equalTo(self.contentView.snp.top)
            make.leading.equalTo(self.cocktailImageView.snp.trailing).offset(LocalConstants.cocktailLabelDefaultAnchor)
            make.trailing.equalTo(self.contentView.snp.trailing)
            make.bottom.equalTo(self.contentView.snp.bottom)
        }
        //        let contentView = self.contentView
        //        let cocktailLabel = self.cocktailLabel
        //        let cocktailImageView = self.cocktailImageView
        //
        //        NSLayoutConstraint.activate([
        //            cocktailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        //            cocktailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: GlobalConstants.defaultPadding * 2),
        //            cocktailImageView.widthAnchor.constraint(equalToConstant: 60.0),
        //            cocktailImageView.heightAnchor.constraint(equalToConstant: 60.0),
        //
        //            cocktailLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
        //            cocktailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        //            cocktailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        //            cocktailLabel.leadingAnchor.constraint(equalTo: cocktailImageView.trailingAnchor, constant: 20.0),
        //        ])
        
    }
    
    func setupCell(with cocktail: Cocktail) {
        let url = URL(string: cocktail.thumbLink ?? "")
        let placeholder = UIImage(named: "placeholder")
        
        self.cocktailImageView.sd_setImage(with: url, placeholderImage: placeholder )
        let cocktailName = cocktail.name
        self.cocktailLabel.text = cocktailName
    }
    
}
