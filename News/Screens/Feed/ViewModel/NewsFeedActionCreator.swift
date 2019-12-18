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
            inputs.reloadTrigger.map { .reload },
            inputs.nextPageTrigger.map { .nextPage },
            inputs.selectArticleTrigger.map { .selectArticle($0) }
        )
    }
    
}
