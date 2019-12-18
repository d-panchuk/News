//
//  Date+ElapsedTimeTests.swift
//  NewsTests
//
//  Created by Dima Panchuk on 17.12.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

@testable import News
import XCTest

class DateElapsedTimeTests: XCTestCase {
    
    let calendar = Calendar.current
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppConstants.Network.dateFormat
        return dateFormatter
    }
    
    func test_getElapsedTime_returnsMomentAgo() {
        XCTAssertEqual(Date().getElapsedTime(), "a moment ago")
        
        let date = calendar.date(byAdding: .day, value: 1, to: Date())!
        XCTAssertEqual(date.getElapsedTime(), "a moment ago")
    }
    
    func test_getElapsedTime_returnsMinutes() {
        var date = calendar.date(byAdding: .minute, value: -1, to: Date())!
        XCTAssertEqual(date.getElapsedTime(), "1 minute ago")
        
        date = calendar.date(byAdding: .minute, value: -9, to: date)!
        XCTAssertEqual(date.getElapsedTime(), "10 minutes ago")
    }
    
    func test_getElapsedTime_returnsHours() {
        var date = calendar.date(byAdding: .hour, value: -1, to: Date())!
        XCTAssertEqual(date.getElapsedTime(), "1 hour ago")
        
        date = calendar.date(byAdding: .hour, value: -9, to: date)!
        XCTAssertEqual(date.getElapsedTime(), "10 hours ago")
    }
    
    func test_getElapsedTime_returnsDays() {
        var date = calendar.date(byAdding: .day, value: -1, to: Date())!
        XCTAssertEqual(date.getElapsedTime(), "1 day ago")
        
        date = calendar.date(byAdding: .day, value: -9, to: date)!
        XCTAssertEqual(date.getElapsedTime(), "10 days ago")
    }
    
    func test_getElapsedTime_returnsMonths() {
        var date = calendar.date(byAdding: .month, value: -1, to: Date())!
        XCTAssertEqual(date.getElapsedTime(), "1 month ago")
        
        date = calendar.date(byAdding: .month, value: -9, to: date)!
        XCTAssertEqual(date.getElapsedTime(), "10 months ago")
    }
    
    func test_getElapsedTime_returnsYears() {
        var date = calendar.date(byAdding: .year, value: -1, to: Date())!
        XCTAssertEqual(date.getElapsedTime(), "1 year ago")
        
        date = calendar.date(byAdding: .year, value: -9, to: date)!
        XCTAssertEqual(date.getElapsedTime(), "10 years ago")
    }
    
}
