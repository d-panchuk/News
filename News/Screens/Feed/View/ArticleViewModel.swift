//
//  ArticleViewModel.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

struct ArticleViewModel {
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    let sourceName: String
    
    init(from dtoModel: ArticleDTO) {
        author = dtoModel.author
        title = dtoModel.title
        description = dtoModel.description
        url = dtoModel.url
        urlToImage = dtoModel.urlToImage
        content = dtoModel.content
        sourceName = dtoModel.source.name
        publishedAt = dtoModel.publishedAt
    }
}

extension ArticleViewModel: Equatable {
    static func == (lhs: ArticleViewModel, rhs: ArticleViewModel) -> Bool {
        return lhs.author == rhs.author
            && lhs.title == rhs.title
            && lhs.description == rhs.description
            && lhs.url == rhs.url
            && lhs.urlToImage == rhs.urlToImage
            && lhs.publishedAt == rhs.publishedAt
            && lhs.content == rhs.content
            && lhs.sourceName == rhs.sourceName
    }
}
