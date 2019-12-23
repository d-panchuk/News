//
//  NewsFeedProps.swift
//  News
//
//  Created by Dima Panchuk on 06.12.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

extension NewsFeed {
    
    static func makeProps(from state: State) -> NewsFeedViewController.Props {
        return NewsFeedViewController.Props(
            articles: state.articles,
            isReloading: state.isLoading,
            errorMessage: state.errorMessage
        )
    }
    
    static func makeArticleCellProps(from viewModel: ArticleViewModel) -> ArticleTableViewCell.Props {
        return ArticleTableViewCell.Props(
            imageUrlPath: viewModel.urlToImage,
            title: viewModel.title,
            description: viewModel.description
        )
    }
    
}
