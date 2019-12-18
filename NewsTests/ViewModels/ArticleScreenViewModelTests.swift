//
//  ArticleScreenViewModelTests.swift
//  NewsTests
//
//  Created by Dima Panchuk on 16.12.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

@testable import News
import XCTest

class ArticleScreenViewModelTests: XCTestCase {
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppConstants.Network.dateFormat
        return dateFormatter
    }
    
    func test_initWithNonEmptyValues() {
        let publishedAt = dateFormatter.string(from: Date())
        let content = "Content"
        let articleViewModel = makeArticleViewModel(content: content, publishedAt: publishedAt)
        let articleScreenViewModel = ArticleScreenViewModel(model: articleViewModel)
        
        let expectedPublishTime = "a moment ago"
        let expectedLinkURL = URL(string: articleViewModel.url)
        
        XCTAssertEqual(articleScreenViewModel.title, articleViewModel.title)
        XCTAssertEqual(articleScreenViewModel.imageUrlPath, articleViewModel.urlToImage)
        XCTAssertEqual(articleScreenViewModel.source, articleViewModel.sourceName)
        XCTAssertEqual(articleScreenViewModel.publishTime, expectedPublishTime)
        XCTAssertEqual(articleScreenViewModel.content, articleViewModel.content)
        XCTAssertEqual(articleScreenViewModel.linkURL, expectedLinkURL)
    }
    
    func test_initWithEmptyValues() {
        let articleViewModel = makeArticleViewModel()
        let articleScreenViewModel = ArticleScreenViewModel(model: articleViewModel)
        
        XCTAssertEqual(articleScreenViewModel.title, articleViewModel.title)
        XCTAssertEqual(articleScreenViewModel.imageUrlPath, articleViewModel.urlToImage)
        XCTAssertEqual(articleScreenViewModel.source, articleViewModel.sourceName)
        XCTAssertEqual(articleScreenViewModel.publishTime, "")
        XCTAssertEqual(articleScreenViewModel.content, "")
        XCTAssertEqual(articleScreenViewModel.linkURL, URL(string: articleViewModel.url))
    }
    
    private func makeArticleViewModel(content: String? = nil, publishedAt: String = "") -> ArticleViewModel {
        func makeArticleDtoMock() -> ArticleDTO {
            return ArticleDTO(source: ArticleDTO.Source(id: nil, name: "BBC"),
                             author: nil, title: "bitcoin", description: nil,
                             url: "http://google.com", urlToImage: "http://google.com/image",
                             publishedAt: publishedAt, content: content)
        }
        
        let articleDto = makeArticleDtoMock()
        return ArticleViewModel(from: articleDto)
    }
    
}
