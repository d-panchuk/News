//
//  RequestTests.swift
//  NewsTests
//
//  Created by Dima Panchuk on 17.12.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

@testable import News
import XCTest

class RequestTests: XCTestCase {
    
    func test_initGetEverythingNewsRequest() {
        let query = "query"
        let page = 1
        let language = "en"
        let sortBy = "publishedAt"
        
        let request = GetEverythingNewsRequest(query: query, page: page, language: language, sortBy: sortBy)
        XCTAssertEqual(request.data.parameters["q"] as? String, query)
        XCTAssertEqual(request.data.parameters["language"] as? String, language)
        XCTAssertEqual(request.data.parameters["sortBy"] as? String, sortBy)
        XCTAssertEqual(request.data.parameters["page"] as? String, page.description)
    }
    
}
