//
//  SearchTableViewCell.swift
//  TechVibeSwift
//
//  Created by devireddy k on 22/08/24.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    let articleImageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let sourceLabel = UILabel()
    let publishedDateLabel = UILabel()
    var searchViewModel: SearchViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true
        articleImageView.layer.cornerRadius = 8
        contentView.addSubview(articleImageView)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 3
        contentView.addSubview(descriptionLabel)
        
        sourceLabel.font = UIFont.systemFont(ofSize: 12)
        sourceLabel.textColor = .systemRed
        contentView.addSubview(sourceLabel)
        
        publishedDateLabel.font = UIFont.systemFont(ofSize: 12)
        publishedDateLabel.textColor = .systemGreen
        contentView.addSubview(publishedDateLabel)
    }
    
    private func setupConstraints() {
        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        sourceLabel.translatesAutoresizingMaskIntoConstraints = false
        publishedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            articleImageView.widthAnchor.constraint(equalToConstant: 80),
            articleImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            
            sourceLabel.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 10),
            sourceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            
            publishedDateLabel.leadingAnchor.constraint(equalTo: sourceLabel.trailingAnchor, constant: 10),
            publishedDateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            publishedDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with article: Article) {
        if let urlString = article.urlToImage, let url = URL(string: urlString) {
            self.searchViewModel?.downloadImage(from: url) { [weak self] image in
                self?.articleImageView.image = image
            }
        } else {
            articleImageView.image = UIImage(named: "placeholder")
        }
        
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        sourceLabel.text = article.source?.name
        publishedDateLabel.text = formattedDate(from: article.publishedAt)
    }
    
    private func formattedDate(from isoDate: String) -> String? {
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: isoDate) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        return nil
    }
}
