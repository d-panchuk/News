//
//  ArticleDTO.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

struct ArticleDTO: Codable {
    struct Source: Codable {
        let id: String?
        let name: String
    }
    
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

extension ArticleDTO {
    var id: String {
        return publishedAt + url
    }
}

extension ArticleDTO {
    enum CodingKeys: String, CodingKey {
        case source
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
        case content
    }
}

extension ArticleDTO.CodingKeys {
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
