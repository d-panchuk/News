//
//  NewsApi.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Combine

struct NewsApi {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getEverythingNews(query: String, page: Int) -> AnyPublisher<PagedArticlesDTO, NetworkError> {
        let request = GetEverythingNewsRequest(query: query, page: page)
        return networkManager.execute(request: request)
    }
    
}
