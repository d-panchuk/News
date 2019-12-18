//
//  ArticleEntityMock.swift
//  NewsTests
//
//  Created by Dima Panchuk on 17.12.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

@testable import News

struct ArticleEntityMock: ArticleEntityProtocol {
    var id: String?
    var author: String?
    var content: String?
    var descriptionText: String?
    var publishedAt: String?
    var sourceName: String?
    var title: String?
    var url: String?
    var urlToImage: String?
}
