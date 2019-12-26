//
//  RemoteDataSource.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Combine

struct RemoteDataSource: DataSource {
    
    let newsApi: NewsApi
    
    init(newsApi: NewsApi = NewsApi()) {
        self.newsApi = newsApi
    }
    
    func getEverythingNews(query: String, page: Int) -> AnyPublisher<PagedArticlesDTO, NetworkError> {
        return newsApi.getEverythingNews(query: query, page: page)
    }
    
}
