//
//  DashboardCollectionViewCell.swift
//  TechVibeSwift
//
//  Created by devireddy k on 21/08/24.
//

import UIKit
class DashboardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!

     func setupUI() {
        backgroundColor = UIColor.systemGray6
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = UIColor.systemBlue
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = UIColor.darkGray
        descriptionLabel.numberOfLines = 3
        descriptionLabel.lineBreakMode = .byTruncatingTail
        countryLabel.font = UIFont.systemFont(ofSize: 12)
        countryLabel.textColor = UIColor.systemRed
        categoryLabel.font = UIFont.systemFont(ofSize: 12)
        categoryLabel.textColor = UIColor.systemGreen
        
    }

    // Configure the cell with data
    func configure(with source: Source?) {
        nameLabel.text = source?.name
        descriptionLabel.text = source?.description
        countryLabel.text = source?.country?.uppercased()
        categoryLabel.text = source?.category?.capitalized
    }
    
    func configure(with article: Article?) {
        nameLabel.text = article?.author
        descriptionLabel.text = article?.title
        countryLabel.text = article?.source?.name?.uppercased()
        categoryLabel.text = article?.publishedAt
    }
}
