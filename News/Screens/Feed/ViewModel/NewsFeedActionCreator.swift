//
//  NewsFeedActionCreator.swift
//  News
//
//  Created by Dima Panchuk on 06.12.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import RxSwift

extension NewsFeed {
    
    static func makeActions(from inputs: ViewModel.Inputs) -> Observable<Action> {
        return Observable.merge(
            inputs.pullToRefresh.map { .reload },
            inputs.contentOffsetChange.map { .isReachedBottom($0) },
            inputs.articleSelect.map { .selectArticle($0) }
        )
    }
    
}
