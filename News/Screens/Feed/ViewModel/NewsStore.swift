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
        var page: Int
        var totalResults: Int?
        var articles: [ArticleViewModel]
        var isLoading: Bool
        var errorMessage: String?
    }
    
    enum Action {
        case reload
        case nextPage
        case selectArticle(ArticleViewModel)
        case isReachedBottom(Bool)
        
        case loadArticlesSuccess(PagedArticlesDTO)
        case loadArticlesFailure(Error)
        
        // FIXME: for debugging
        var description: String {
            switch self {
            case .reload:
                return "reload"
            case .nextPage:
                return "nextPage"
            case .selectArticle(_):
                return "selectArticle"
            case .loadArticlesSuccess(_):
                return "loadArticlesSuccess"
            case .loadArticlesFailure(_):
                return "loadArticlesFailure"
            }
        }
    }
    
    static func reduce(state: State, action: Action) -> State {
        var newState = state
        
        switch action {
        case .nextPage:
            newState.isLoading = true
            newState.page += 1
        
        case .reload:
            newState.isLoading = true
            newState.articles = []
            newState.page = 1
        
        case .loadArticlesSuccess(let articlesDto):
            newState.isLoading = false
            newState.totalResults = articlesDto.totalResults
            newState.articles += articlesDto.articles.map { ArticleViewModel(from: $0) }
        
        case .loadArticlesFailure(let error):
            newState.isLoading = false
            newState.errorMessage = error.localizedDescription

        case .selectArticle, .isReachedBottom:
            break
            
        }
        
        return newState
    }
    
}
