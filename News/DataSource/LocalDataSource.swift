//
//  LocalDataSource.swift
//  News
//
//  Created by Dima Panchuk on 22.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Combine

struct LocalDataSource: DataSource {
    
    let newsPersistenceManager: NewsPersistenceManager
    
    init(newsPersistenceManager: NewsPersistenceManager = NewsPersistenceManager()) {
        self.newsPersistenceManager = newsPersistenceManager
    }
    
    func saveArticles(_ articles: [ArticleDTO], for query: String, page: Int) {
        newsPersistenceManager.saveArticlesIfNeeded(articles)
        
        let articleIds = articles.map { $0.id }
        newsPersistenceManager.saveArticleIds(articleIds, for: query, page: page)
    }
    
    func getEverythingNews(query: String, page: Int) -> AnyPublisher<PagedArticlesDTO, NetworkError> {
        let articles = newsPersistenceManager.getArticles(for: query, page: page).compactMap { ArticleDTO(from: $0) }
        let totalResults = newsPersistenceManager.getTotalResults(for: query)
        let pagedResponse = PagedArticlesDTO(status: "OK", totalResults: totalResults, articles: articles)
        
        return Future<PagedArticlesDTO, NetworkError> { promise in
            promise(.success(pagedResponse))
        }.eraseToAnyPublisher()
    }
    
}
