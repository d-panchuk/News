//
//  NetworkDispatcher.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

struct URLSessionNetworkDispatcher: NetworkDispatcher {
    
    func dispatch(requestData: RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (NetworkError) -> Void) -> URLSessionTask? {
        let result = buildRequest(from: requestData)
        var request: URLRequest
        
        switch result {
        case .success(let _request):
            request = _request
        case .failure(let _error):
            onError(_error)
            return nil
        }
        
        #if DEBUG
        // Note: uncomment to see debug logs
//        NetworkLogger.logRequest(request)
        #endif
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onError(NetworkError.requestError(description: error.localizedDescription))
                return
            }
                        
            guard let data = data else {
                onError(NetworkError.noResponseData)
                return
            }
            
            #if DEBUG
            // Note: uncomment to see debug logs
//            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
//                NetworkLogger.logResponse(from: requestData.endpoint, response: json)
//            }
            #endif
            
            if let apiError = try? JSONDecoder().decode(ApiError.self, from: data) {
                onError(NetworkError.requestError(description: apiError.description))
                return
            }
            
            onSuccess(data)
        }
        
        dataTask.resume()
        
        return dataTask
    }

}

private extension URLSessionNetworkDispatcher {
    
    func buildRequest(from requestData: RequestData) -> Result<URLRequest, NetworkError> {
        let path = (requestData.method == .get) ? buildPathWithParams(from: requestData) : requestData.endpoint.path
        
        guard let url = URL(string: path) else {
            return .failure(NetworkError.invalidRequestUrl)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestData.method.rawValue
        
        do {
            if !requestData.parameters.isEmpty, requestData.method != .get {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestData.parameters)
            }
        } catch {
            return .failure(NetworkError.invalidRequestBody(description: error.localizedDescription))
        }
        
        if !requestData.headers.isEmpty {
            urlRequest.allHTTPHeaderFields = requestData.headers
        }
        
        return .success(urlRequest)
    }
    
    func buildPathWithParams(from requestData: RequestData) -> String {
        var components = URLComponents(string: requestData.endpoint.path)
        
        
        components?.queryItems =
            requestData.parameters
            .compactMapValues { $0 as? String }
            .map { URLQueryItem(name: $0, value: $1) }
        
        return components?.url?.absoluteString ?? requestData.endpoint.path
    }
    
}

extension Dictionary {
    public func compactMapValues<T>(_ transform: (Value) throws -> T?) rethrows -> [Key: T] {
        return try self.reduce(into: [Key: T](), { (result, x) in
            if let value = try transform(x.value) {
                result[x.key] = value
            }
        })
    }
}
