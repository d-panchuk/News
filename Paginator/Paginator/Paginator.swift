//
//  Paginator.swift
//  Paginator
//
//  Created by Dima Panchuk on 25.12.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Darwin

public enum RequestStatus {
    case none, inProgress, done
}

public class Paginator<Element, ErrorType> {
    
    // MARK: - Typealiases
    
    public typealias FetchHandlerType = (_ page: Int) -> Void
    public typealias ResultsHandler = ([Element]) -> Void
    public typealias ResetHandler = () -> Void
    public typealias FailureHandler = (ErrorType) -> Void
    public typealias CompletionHandler = () -> Void
    
    // MARK: - Properties
    
    public private(set) var page = 0
    public private(set) var totalResultsCount = 0
    public private(set) var requestStatus: RequestStatus = .none
        
    public var pageSize = 0
    public var results: [Element] = []
    
    public var fetchHandler: FetchHandlerType
    public var resultsHandler: ResultsHandler
    public var resetHandler: ResetHandler?
    public var failureHandler: FailureHandler?
    public var completionHandler: CompletionHandler?
    
    // MARK: - Computed properties
    
    var totalPagesCount: Int {
        guard pageSize != 0 else { return 0 }
        let total = ceil(Double(totalResultsCount) / Double(pageSize))
        return Int(total)
    }
    
    var didReachLastPage: Bool {
        guard requestStatus != .none else { return false }
        return page >= totalPagesCount
    }
    
    var didFetchAllResults: Bool {
        return results.count >= totalResultsCount
    }
    
    // MARK: - Inits
    
    public init(pageSize: Int,
                fetchHandler: @escaping FetchHandlerType,
                resultsHandler: @escaping ResultsHandler,
                resetHandler: ResetHandler? = nil,
                failureHandler: FailureHandler? = nil,
                completionHandler: CompletionHandler? = nil) {
        
        self.pageSize = pageSize
        self.fetchHandler = fetchHandler
        self.resultsHandler = resultsHandler
        self.failureHandler = failureHandler
        self.resetHandler = resetHandler
        self.completionHandler = completionHandler
        self.setDefaultValues()
    }
    
    // MARK: - Public methods
    
    public func reset() {
        setDefaultValues()
        resetHandler?()
    }
        
    public func fetchFirstPage() {
        reset()
        fetchNextPage()
    }
    
    public func fetchNextPage() {
        guard requestStatus != .inProgress, !didReachLastPage else { return }
        requestStatus = .inProgress
        fetchHandler(page + 1)
    }
    
    public func received(results: [Element], total: Int) {
        self.results.append(contentsOf: results)
        self.totalResultsCount = total
        page += 1
        requestStatus = .done
        
        resultsHandler(results)
        
        if didFetchAllResults {
            self.completionHandler?()
        }
    }
    
    public func failed(error: ErrorType) {
        requestStatus = .done
        failureHandler?(error)
    }
    
    public func results(at page: Int) -> [Element] {
        guard page <= totalResultsCount else { return [] }
        let start = page * pageSize
        let end = min(start + pageSize, results.count - 1)
        return Array(results[start...end])
    }
    
    // MARK: - Private methods
    
    private func setDefaultValues() {
        totalResultsCount = 0
        page = 0
        requestStatus = .none
        results = []
    }
    
}
