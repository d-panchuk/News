//
//  NewsApiEndpoint.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

protocol Endpoint {
    var path: String { get }
}

enum NewsApiEndpoint {
    case everything
    case topHeadlines
    case sources
}

extension NewsApiEndpoint: Endpoint {
    var basePath: String {
        return AppConstants.Network.newsApiBasePath
    }
    
    var path: String {
        switch self {
        case .everything:
            return basePath + "/everything"
        case .topHeadlines:
            return basePath + "/top-headlines"
        case .sources:
            return basePath + "/sources"
        }
    }
}
