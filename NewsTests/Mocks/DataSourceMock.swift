//
//  DataSourceMock.swift
//  NewsTests
//
//  Created by Dima Panchuk on 22.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

@testable import News
import RxSwift

class DataSourceMock: DataSource {
    
    var getEverythingNewsResult: Single<PagedArticlesDTO>!
    func getEverythingNews(query: String, page: Int) -> Single<PagedArticlesDTO> {
        return getEverythingNewsResult
    }
    
}
