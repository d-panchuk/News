//
//  NewsFeedViewModel.swift
//  News
//
//  Created by Dima Panchuk on 06.12.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import RxSwift
import Combine

extension NewsFeed {
    
    enum Route {
        case articleDetails(ArticleViewModel)
    }
    
    class ViewModel {
                
        struct Inputs {
            let pullToRefresh: Observable<Void>
            let contentOffsetChange: Observable<Bool>
            let articleSelect: Observable<ArticleViewModel>
        }
        
        struct Outputs {
            let props: AnyPublisher<NewsFeedViewController.Props, Never>
            let stateChanges: Observable<Void>
            let route: Observable<Route>
        }
        
        func makeOutputs(from inputs: Inputs) -> Outputs {
            let initialState = State(page: 0, totalResults: nil, articles: [], isLoading: false, errorMessage: nil)
            let store = Store(
                initialState: initialState,
                reducer: reduce,
                middlewares: [loadMiddleware(), infiniteScrollMiddleware()]
            )
            
            let actions = makeActions(from: inputs)
            
            let props = store.state
                .removeDuplicates()
                .map(makeProps)
                .eraseToAnyPublisher()
            
            let stateChanges = actions
                .do(onNext: store.dispatch)
                .map { _ in Void() }
            
            let route = inputs.articleSelect
                .map(Route.articleDetails)
            
            return Outputs(props: props, stateChanges: stateChanges, route: route)
        }
        
    }
    
}
