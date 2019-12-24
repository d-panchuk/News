//
//  NewsFeedViewModel.swift
//  News
//
//  Created by Dima Panchuk on 06.12.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Combine

extension NewsFeed {
    
    enum Route {
        case articleDetails(ArticleViewModel)
    }
    
    class ViewModel {
        
        struct Inputs {
            let pullToRefresh: AnyPublisher<Void, Never>
            let contentOffsetChange: AnyPublisher<Bool, Never>
            let articleSelect: AnyPublisher<Int, Never>
        }
        
        struct Outputs {
            let props: AnyPublisher<NewsFeedViewController.Props, Never>
            let stateChanges: AnyPublisher<Void, Never>
            let route: AnyPublisher<Route, Never>
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
                .handleEvents(receiveOutput: store.dispatch)
                .map { _ in Void() }
                .eraseToAnyPublisher()
            
            let route = inputs.articleSelect
                .map { selectedIndex in store.getState().articles[selectedIndex] }
                .map(Route.articleDetails)
                .eraseToAnyPublisher()
            
            return Outputs(props: props, stateChanges: stateChanges, route: route)
        }
        
    }
    
}
