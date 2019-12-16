//
//  CacheableDataSource.swift
//  News
//
//  Created by Dima Panchuk on 22.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import RxSwift

struct CacheableDataSource: DataSource {
    
    let remoteDataSource: RemoteDataSource
    let localDataSource: LocalDataSource
    
    init(
        remoteDataSource: RemoteDataSource = RemoteDataSource(),
        localDataSource: LocalDataSource = LocalDataSource()
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func getEverythingNews(query: String, page: Int) -> Single<PagedArticlesDTO> {
        let pagedArticles: Single<PagedArticlesDTO>

        if UIDevice.isConnectedToNetwork {
            pagedArticles = remoteDataSource.getEverythingNews(query: query, page: page)
                .do(onSuccess: { pagedArticles in
                    self.localDataSource.saveArticles(pagedArticles.articles, for: query, page: page)
                })
        } else {
            pagedArticles = localDataSource.getEverythingNews(query: query, page: page)
        }
        
        return pagedArticles
    }
    
}
