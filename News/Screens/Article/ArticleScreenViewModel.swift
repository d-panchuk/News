//
//  ArticleScreenViewModel.swift
//  News
//
//  Created by Dima Panchuk on 21.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import RxSwift

final class ArticleScreenViewModel {
    
    private var model: ArticleViewModel
    
    init(model: ArticleViewModel) {
        self.model = model
    }
    
    var title: String {
        return model.title
    }
    
    var imageUrlPath: String? {
        return model.urlToImage
    }
    
    var source: String {
        return model.sourceName
    }
    
    var publishTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppConstants.Network.dateFormat
        let publishDate = dateFormatter.date(from: model.publishedAt)
        return publishDate?.getElapsedTime() ?? ""
    }
    
    var content: String {
        return model.content ?? ""
    }
    
    var linkURL: URL? {
        return URL(string: model.url)
    }
    
}
