//
//  NewsStore.swift
//  News
//
//  Created by Dima Panchuk on 06.12.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit

extension NewsFeed {
    
    typealias Store = ReduxStore<State, Action>
    
    struct State: Equatable {
        var articles: [ArticleViewModel]
        var isLoading: Bool
        var errorMessage: String?
    }
    
    enum Action {
        case reload
        case nextPage
        case selectArticle(Int)
        case isReachedBottom(Bool)
        
        case loadArticlesSuccess([ArticleDTO])
        case loadArticlesFailure(Error)
        
        var description: String {
            let fullDescription = String.init(describing: self)
            let lastIndex = fullDescription.firstIndex(of: "(") ?? fullDescription.endIndex
            return String(fullDescription.prefix(upTo: lastIndex))
        }
    }
    
    static func reduce(state: State, action: Action) -> State {
        var newState = state
        
        switch action {
        case .nextPage:
            newState.isLoading = true
        
        case .reload:
            newState.isLoading = true
            newState.articles = []
        
        case .loadArticlesSuccess(let articles):
            newState.isLoading = false
            newState.articles += articles.map { ArticleViewModel(from: $0) }
        
        case .loadArticlesFailure(let error):
            newState.isLoading = false
            newState.errorMessage = error.localizedDescription

        case .selectArticle, .isReachedBottom:
            break
            
        }
        
        return newState
    }
    
}
