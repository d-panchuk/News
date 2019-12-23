//
//  DataSource.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Combine

protocol DataSource {
    func getEverythingNews(query: String, page: Int) -> AnyPublisher<PagedArticlesDTO, NetworkError>
}
