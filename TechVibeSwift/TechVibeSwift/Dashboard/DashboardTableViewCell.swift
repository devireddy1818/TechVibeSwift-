//
//  DashboardTableViewCell.swift
//  TechVibeSwift
//
//  Created by devireddy k on 21/08/24.
//

import UIKit
protocol DashboardDashboardTableViewCellDelegate: AnyObject {
    func didTaponSourceItem(index: Int?, source: String?)
}
class DashboardTableViewCell: UITableViewCell {
    @IBOutlet weak var dashboardCollectionView: UICollectionView!
    weak var delegate: DashboardDashboardTableViewCellDelegate?
    var sources: [Source]?
    var articles: [Article]?
    var newsType: NewsType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.dashboardCollectionView.dataSource = self
        self.dashboardCollectionView.delegate = self
    }
    
    func configure(with sources: [Source]?) {
        self.sources = sources
        DispatchQueue.main.async  { [weak self] in
            self?.dashboardCollectionView.reloadData()
        }
    }
    
    func configure(with articles: [Article]?) {
        self.articles = articles
        DispatchQueue.main.async  { [weak self] in
            self?.dashboardCollectionView.reloadData()
        }
    }
}

extension DashboardTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch newsType {
        case .headline:
            return self.articles?.count ?? 0
        case .source:
            return self.sources?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardCollectionViewCell", for: indexPath) as? DashboardCollectionViewCell
        cell?.setupUI()
        switch self.newsType {
        case .headline:
            cell?.configure(with: self.articles?[indexPath.item])
        case .source:
            cell?.configure(with: self.sources?[indexPath.item])
        default: break
        }
        cell?.setNeedsLayout()
        cell?.layoutIfNeeded()
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var source = ""
        switch self.newsType {
        case .headline:
            source = self.articles?[indexPath.item].url ?? ""
        case .source:
            source = self.sources?[indexPath.item].url ?? ""
        default: break
        }
        self.delegate?.didTaponSourceItem(index: indexPath.item, source: source)
    }
}
