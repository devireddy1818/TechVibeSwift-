//
//  TopHeadlinesModel.swift
//  TechVibeSwift
//
//  Created by devireddy k on 21/08/24.
//

import Foundation

// MARK: - NewsResponse
struct TopHeadlinesModel: Codable {
    let totalResults: Int?
    let status: String?
    let articles: [Article]?
}

// MARK: - Article
struct Article: Codable {
    let author: String?
    let content: String?
    let description: String?
    let publishedAt: String
    let source: Source?
    let title: String?
    let url: String?
    let urlToImage: String?
}
