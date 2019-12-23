//
//  NewsFeedLoadMiddleware.swift
//  News
//
//  Created by Dima Panchuk on 06.12.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Combine
 
extension NewsFeed {
    
    static func loadMiddleware(dataSource: DataSource = CacheableDataSource()) -> Store.Middleware {
        var cancellables = Set<AnyCancellable>()
        return Store.makeMiddleware { dispatch, getState, next, action in
            print("middleware call with action \(action.description)")
            
            let oldState = getState()
            if let totalResults = oldState.totalResults, oldState.articles.count >= totalResults { return }
            
            next(action)
            
            let state = getState()
            
            switch action {
            case .nextPage, .reload:
                let query = "bitcoin" // FIXME
                
                print("middleware get news at page \(state.page)")
                
                dataSource.getEverythingNews(query: query, page: state.page)
                    .sink(
                        receiveCompletion: { completion in
                            if case .failure(let error) = completion {
                                dispatch(.loadArticlesFailure(error))
                            }
                        },
                        receiveValue: { dispatch(.loadArticlesSuccess($0)) }
                    )
                    .store(in: &cancellables)
            
            default:
                return
            }
            
        }
    }
    
    static func infiniteScrollMiddleware() -> Store.Middleware {
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
