//
//  ArticleDTOTests.swift
//  NewsTests
//
//  Created by Dima Panchuk on 17.12.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

@testable import News
import XCTest

class ArticleDTOTests: XCTestCase {

    func test_initFromEntity_success() {
        let publishedAt = "2019-12-17T12:15:43+0200"
        let url = "http://google.com/articlePath"
        let entity = makeArticleEntity(publishedAt: publishedAt, url: url)
        let articleDto = ArticleDTO(from: entity)

        XCTAssertNotNil(articleDto)
        XCTAssertEqual(articleDto!.id, publishedAt + url)
    }
    
    func test_initFromEntity_nil() {
        let entity = makeArticleEntity(publishedAt: nil, url: nil)
        let articleDto = ArticleDTO(from: entity)
        
        XCTAssertNil(articleDto)
    }
    
    private func makeArticleEntity(publishedAt: String?, url: String?) -> ArticleEntityProtocol {
        let id = (publishedAt ?? "") + (url ?? "")
        let entity = ArticleEntityMock(
            id: id,
            author: "author",
            content: "content",
            descriptionText: "descriptionText",
            publishedAt: publishedAt,
            sourceName: "sourceName",
            title: "title",
            url: url,
            urlToImage: "http://google.com/image"
        )
        return entity
    }
    
}
