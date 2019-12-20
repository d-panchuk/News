//
//  NewsFeedViewModel.swift
//  News
//
//  Created by Dima Panchuk on 06.12.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import RxSwift

extension NewsFeed {
    
    enum Route {
        case articleDetails(ArticleViewModel)
    }
    
    class ViewModel {
        
        struct Inputs {
            let reloadTrigger: Observable<Void>
            let nextPageTrigger: Observable<Void>
            let selectArticleTrigger: Observable<ArticleViewModel>
        }
        
        struct Outputs {
            let props: Observable<NewsFeedViewController.Props>
            let stateChanges: Observable<Void>
            let route: Observable<Route>
        }
        
        func makeOutputs(from inputs: Inputs) -> Outputs {
            let initialState = State(page: 0, totalResults: nil, articles: [], isLoading: false, errorMessage: nil)
            let store = Store(
                initialState: initialState,
                reducer: reduce,
                middlewares: [loadMiddleware()]
            )
            
            let actions = makeActions(from: inputs)
            
            let props = store.state
                .map(makeProps)
            
            let stateChanges = actions
                .do(onNext: store.dispatch)
                .map { _ in Void() }
            
            let route = inputs.selectArticleTrigger
                .map(Route.articleDetails)
            
            return Outputs(props: props, stateChanges: stateChanges, route: route)
        }
        
    }
    
}
