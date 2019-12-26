//
//  NewsFeedLoadMiddleware.swift
//  News
//
//  Created by Dima Panchuk on 06.12.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Combine
import Paginator

extension NewsFeed {
    
    private static var paginator: Paginator<ArticleDTO, NetworkError> {
        Paginator<ArticleDTO, NetworkError>(
            pageSize: AppConstants.Network.pageSize,
            fetchHandler: { _ in },
            resultsHandler: { _ in }
        )
    }
    
    static func makeNewsFetcherMiddleware(
        dataSource: DataSource = CacheableDataSource(),
        paginator: Paginator<ArticleDTO, NetworkError> = paginator
    ) -> Store.Middleware {
        
        var cancellables = Set<AnyCancellable>()
        
        return Store.makeMiddleware { dispatch, getState, next, action in
            print("middleware call with action \(action.description)")
            
            next(action)
            
            paginator.fetchHandler = { page in
                let query = "bitcoin" // FIXME
                dataSource.getEverythingNews(query: query, page: page)
                    .sink(
                        receiveCompletion: { completion in
                            if case .failure(let error) = completion {
                                paginator.failed(error: error)
                            }
                    },
                        receiveValue: {
                            paginator.received(results: $0.articles, total: $0.totalResults)
                        }
                    )
                    .store(in: &cancellables)
            }
            paginator.resultsHandler = { dispatch(.loadArticlesSuccess($0)) }
            paginator.failureHandler = { dispatch(.loadArticlesFailure($0)) }
            
            switch action {
            case .nextPage:
                paginator.fetchNextPage()
            
            case .reload:
                paginator.fetchFirstPage()
            
            default:
                return
            }
            
        }
    }
    
    static func makeInfiniteScrollMiddleware() -> Store.Middleware {
        return Store.makeMiddleware { dispatch, getState, next, action in
            next(action)
            
            guard case .isReachedBottom(let isReachedBottom) = action else { return }
            
            let state = getState()
            if isReachedBottom && !state.isLoading {
                dispatch(.nextPage)
            }
        }
    }
    
}
