//
//  DataSource.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import RxSwift

protocol DataSource {
    func getEverythingNews(query: String, page: Int) -> Single<PagedArticlesDTO>
}
