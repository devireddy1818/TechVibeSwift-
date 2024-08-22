//
//  SourceModel.swift
//  TechVibeSwift
//
//  Created by devireddy k on 21/08/24.
//

import Foundation

struct Source: Codable {
    let category: String?
    let country: String?
    let description: String?
    let id: String?
    let language: String?
    let name: String?
    let url: String?
}

struct SourceModel: Codable {
    let status: String?
    let sources: [Source]?
}
