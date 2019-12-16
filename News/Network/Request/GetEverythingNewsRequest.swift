//
//  GetEverythingNewsRequest.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

struct GetEverythingNewsRequest: RequestType {
    
    let query: String
    let page: Int
    let language: String
    let sortBy: String
    
    init(query: String, page: Int, language: String = "en", sortBy: String = "publishedAt") {
        self.query = query
        self.language = language
        self.sortBy = sortBy
        self.page = page
    }
    
    var data: RequestData {
        return RequestData(
            endpoint: NewsApiEndpoint.everything,
            method: .get,
            parameters: [
                "q": query,
                "language": language,
                "sortBy": sortBy,
                "pageSize": AppConstants.Network.pageSize.description,
                "page" : page.description,
                "apiKey" : AppConstants.Network.newsApiKey
            ]
        )
    }
    
}
