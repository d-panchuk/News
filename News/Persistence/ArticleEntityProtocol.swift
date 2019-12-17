//
//  ArticleEntityProtocol.swift
//  News
//
//  Created by Dima Panchuk on 17.12.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

protocol ArticleEntityProtocol {
    var id: String? { get set }
    var author: String? { get set }
    var content: String? { get set }
    var descriptionText: String? { get set }
    var publishedAt: String? { get set }
    var sourceName: String? { get set }
    var title: String? { get set }
    var url: String? { get set }
    var urlToImage: String? { get set }
}
