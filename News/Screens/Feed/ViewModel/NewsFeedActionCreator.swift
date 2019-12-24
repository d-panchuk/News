//
//  NewsFeedActionCreator.swift
//  News
//
//  Created by Dima Panchuk on 06.12.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Combine

extension NewsFeed {
    
    static func makeActions(from inputs: ViewModel.Inputs) -> AnyPublisher<Action, Never> {
        return Publishers.Merge3(
            inputs.pullToRefresh.map { .reload },
            inputs.contentOffsetChange.map { .isReachedBottom($0) },
            inputs.articleSelect.map { .selectArticle($0) }
        ).eraseToAnyPublisher()
    }
    
}
