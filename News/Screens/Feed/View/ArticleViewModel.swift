//
//  ArticleViewModel.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

struct ArticleViewModel: Equatable {
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    let sourceName: String
}

extension ArticleViewModel {
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
