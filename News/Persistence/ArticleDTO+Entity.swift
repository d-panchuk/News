//
//  ArticleDTO+Entity.swift
//  News
//
//  Created by Dima Panchuk on 22.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

extension ArticleEntity: ArticleEntityProtocol {}

extension ArticleDTO {
    
    init?(from entity: ArticleEntityProtocol) {
        guard let sourceName = entity.sourceName,
            let title = entity.title,
            let url = entity.url,
            let publishedAt = entity.publishedAt
        else {
            return nil
        }
        
        self.source = Source(id: nil, name: sourceName)
        self.author = entity.author
        self.title = title
        self.description = entity.descriptionText
        self.url = url
        self.urlToImage = entity.urlToImage
        self.publishedAt = publishedAt
        self.content = entity.content
    }
    
    func setupArticleEntity(_ entity: ArticleEntity) {
        entity.id = id
        entity.author = author
        entity.content = content
        entity.descriptionText = description
        entity.publishedAt = publishedAt
        entity.sourceName = source.name
        entity.title = title
        entity.url = url
        entity.urlToImage = urlToImage
    }
    
}
