//
//  NetworkManager.swift
//  News
//
//  Created by Dima Panchuk on 20.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation
import Combine

struct NetworkManager {
    
    private let dispatcher: NetworkDispatcher
    
    init(dispatcher: NetworkDispatcher = URLSessionNetworkDispatcher()) {
        self.dispatcher = dispatcher
    }
    
    func execute<ResponseType: Codable>(
        request: RequestType,
        onSuccess: @escaping (ResponseType) -> Void,
        onError: @escaping (NetworkError) -> Void
    ) -> URLSessionTask? {

        return dispatcher.dispatch(
            requestData: request.data,
            onSuccess: { data in
                do {
                    let result = try JSONDecoder().decode(ResponseType.self, from: data)
                    onSuccess(result)
                } catch let error {
                    onError(NetworkError.undecodableResponse(description: error.localizedDescription))
                }
            },
            onError: { (error: NetworkError) in
                onError(error)
            }
        )
    }
    
    func execute<ResponseType: Codable>(request: RequestType) -> AnyPublisher<ResponseType, NetworkError> {
        return Future<ResponseType, NetworkError> { promise in
            let task = self.execute(
                request: request,
                onSuccess: { response in
                    promise(.success(response))
                },
                onError: { error in
                    promise(.failure(error))
                }
            )
            
//            Disposables.create { task?.cancel() } // FIXME: does Future cancels requests under the hood?
        }.eraseToAnyPublisher()
    }
    
}
