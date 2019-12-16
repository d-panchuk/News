//
//  NewsFeedViewModel.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import RxSwift
import RxCocoa

final class NewsFeedViewModel {
    
    // MARK: Inputs
    let reloadTrigger: AnyObserver<Void>
    let nextPageTrigger: AnyObserver<Void>
    let selectArticleTrigger: AnyObserver<ArticleViewModel>
    
    // MARK: Outputs
    let articles: Driver<[ArticleViewModel]>
    let showArticle: Observable<ArticleViewModel>
    let errorMessage: Driver<String>
    
    // MARK: Initializers
    init(dataSource: DataSource = CacheableDataSource()) {
        let _reloadTrigger = PublishSubject<Void>()
        self.reloadTrigger = _reloadTrigger.asObserver()
        
        let _nextPageTrigger = PublishSubject<Void>()
        self.nextPageTrigger = _nextPageTrigger.asObserver()
        
        let _articles = BehaviorSubject<[ArticleViewModel]>(value: [])
        self.articles = _articles.asDriver(onErrorJustReturn: [])
        
        let _selectArticleTrigger = PublishSubject<ArticleViewModel>()
        self.selectArticleTrigger = _selectArticleTrigger.asObserver()
        self.showArticle = _selectArticleTrigger.asObservable()
        
        let _errorMessage = PublishSubject<String>()
        self.errorMessage = _errorMessage.asDriver(onErrorJustReturn: "Unknown error")
        
        let query = "bitcoin"
        var pageToLoad = 0
        
        let resetNextPage = Observable<Void>.create { observer in
            pageToLoad = 0
            _articles.onNext([])
            observer.onCompleted()
            return Disposables.create()
        }
        let _reset = _reloadTrigger.flatMap { resetNextPage }
        
        let nextPage = Observable<Int>.create { observer in
            pageToLoad += 1
            observer.onNext(pageToLoad)
            observer.onCompleted()
            return Disposables.create()
        }
        
        let nextArticles = nextPage
            .flatMap { page in
                dataSource.getEverythingNews(query: query, page: page)
                    .catchError { error in
                        let message = self.message(from: error)
                        _errorMessage.onNext(message)
                        return Single.just(PagedArticlesDTO.empty)
                }
            }
            .map { pagedArticles in
                pagedArticles.articles.map { ArticleViewModel(from: $0) }
            }
        
        _ = _nextPageTrigger
            .flatMap { nextArticles }
            .flatMap { newArticles in
                Observable<Void>.create { observer in
                    if let oldArticles = try? _articles.value() {
                        _articles.onNext(oldArticles + newArticles)
                    }
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
            .subscribe()
        
        _ = _reset
            .flatMap { nextArticles }
            .flatMap { newArticles in
                Observable<Void>.create { observer in
                    _articles.onNext(newArticles)
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
            .subscribe()
    }
    
    // MARK: Private methods
    private func message(from error: Error) -> String {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .invalidRequestBody(let description),
                 .requestError(let description),
                 .undecodableResponse(let description):
                return description
            default:
                break
            }
        }
        
        return error.localizedDescription
    }
    
}
