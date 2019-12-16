//
//  NetworkUtils.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Swift.Error {
    case invalidRequestUrl
    case invalidRequestBody(description: String)
    case requestError(description: String)
    case noResponseData
    case undecodableResponse(description: String)
}
