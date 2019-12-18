//
//  NewsFeedLoadMiddleware.swift
//  News
//
//  Created by Dima Panchuk on 06.12.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import RxSwift
 
extension NewsFeed {
    
    static func loadMiddleware(dataSource: DataSource = CacheableDataSource()) -> Store.Middleware {
        let disposeBag = DisposeBag()
        return Store.makeMiddleware { dispatch, getState, next, action in
            
            print("middleware call with action \(action.description)")
            
            next(action)
            
            let state = getState()
            
            switch action {
            case .nextPage, .reload:
                let query = "bitcoin" // FIXME
                print("middleware get news at page \(state.page)")
                dataSource.getEverythingNews(query: query, page: state.page)
                    .map { pagedArticles in pagedArticles.articles.map { ArticleViewModel(from: $0) } }
                    .do(
                        onSubscribed: { dispatch(.loadArticles) }
                    )
                    .subscribe(
                        onSuccess: { dispatch(.loadArticlesSuccess($0)) },
                        onError: { dispatch(.loadArticlesFailure($0)) }
                    )
                    .disposed(by: disposeBag)
            
            default:
                return
            }
            
        }
    }
    
}
