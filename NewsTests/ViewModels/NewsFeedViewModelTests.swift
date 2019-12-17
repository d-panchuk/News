//
//  NewsFeedViewModelTests.swift
//  NewsTests
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

@testable import News
import XCTest
import RxTest
import RxSwift

class NewsFeedViewModelTests: XCTestCase {

    var testScheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var dataSourceMock: DataSourceMock!
    var viewModel: NewsFeedViewModel!
    
    override func setUp() {
        testScheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        dataSourceMock = DataSourceMock()
        viewModel = NewsFeedViewModel(dataSource: dataSourceMock)
    }
    
    func test_nextPageTrigger_emitsArticles() {
        let articleDtoMock = makeArticleDtoMock(title: "2")
        let resultMock = PagedArticlesDTO(status: "Ok", totalResults: 1, articles: [articleDtoMock])
        let resultModels = [ArticleViewModel(from: articleDtoMock)]
        dataSourceMock.getEverythingNewsResult = .just(resultMock)
        
        testScheduler.createHotObservable([next(250, ())])
            .bind(to: viewModel.nextPageTrigger)
            .disposed(by: disposeBag)
        
        let result = testScheduler.start { self.viewModel.articles.asObservable() }
        let expected = [next(200, []), next(250, resultModels)]
        
        XCTAssertEqual(result.events.count, 2)
        XCTAssertEqual(result.events, expected)
    }
    
    func test_nextPageTrigger_emitsErrorMessage() {
        let errorDescription = "Error Description"
        let error = NetworkError.requestError(description: errorDescription)
        dataSourceMock.getEverythingNewsResult = .error(error)
        
        testScheduler.createHotObservable([next(300, ())])
            .bind(to: viewModel.nextPageTrigger)
            .disposed(by: disposeBag)
        
        let result = testScheduler.start { self.viewModel.errorMessage.asObservable() }
        let expected = [next(300, errorDescription)]
        
        XCTAssertEqual(result.events, expected)
    }
    
    func test_selectArticleTrigger_emitsShowArticle() {
        let articleDtoMock = makeArticleDtoMock(title: "3")
        let articleViewModel = ArticleViewModel(from: articleDtoMock)
        let selectArticleObservable = testScheduler.createHotObservable([next(300, articleViewModel)])
        
        selectArticleObservable
            .bind(to: viewModel.selectArticleTrigger)
            .disposed(by: disposeBag)
        
        let result = testScheduler.start { self.viewModel.showArticle }
        let expected = [next(300, articleViewModel)]
        
        XCTAssertEqual(result.events, expected)
    }
    
    func test_reloadTrigger_resetsArticles() {
        let articleDtoMock = makeArticleDtoMock(title: "2")
        let resultMock = PagedArticlesDTO(status: "Ok", totalResults: 1, articles: [articleDtoMock])
        let resultModels = [ArticleViewModel(from: articleDtoMock)]
        dataSourceMock.getEverythingNewsResult = .just(resultMock)
        
        testScheduler.createHotObservable([next(250, ())])
            .bind(to: viewModel.nextPageTrigger)
            .disposed(by: disposeBag)
        
        testScheduler.createHotObservable([next(300, ())])
            .bind(to: viewModel.reloadTrigger)
            .disposed(by: disposeBag)
        
        let result = testScheduler.start { self.viewModel.articles.asObservable() }
        
        XCTAssertEqual(result.events.count, 3)
        XCTAssertEqual(result.events, [next(200, []), next(250, resultModels), next(300, [])])
    }

    private func makeArticleDtoMock(title: String = "bitcoin") -> ArticleDTO {
        return ArticleDTO(source: ArticleDTO.Source(id: nil, name: "BBC"),
                         author: nil, title: title, description: nil,
                         url: "http://google.com", urlToImage: nil,
                         publishedAt: "2019-11-03T15:00:00Z", content: nil)
    }
    
}
