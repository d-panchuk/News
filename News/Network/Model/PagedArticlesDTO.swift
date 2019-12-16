//
//  PagedArticlesDTO.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

struct PagedArticlesDTO: Codable {
    let status: String
    let totalResults: Int
    let articles: [ArticleDTO]
}

extension PagedArticlesDTO {
    static var empty: PagedArticlesDTO {
        return PagedArticlesDTO(status: "", totalResults: 0, articles: [])
    }
}
