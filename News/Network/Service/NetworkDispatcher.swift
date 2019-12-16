//
//  NetworkDispatcher.swift
//  News
//
//  Created by Dima Panchuk on 21.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

protocol NetworkDispatcher {
    func dispatch(
        requestData: RequestData,
        onSuccess: @escaping (Data) -> Void,
        onError: @escaping (NetworkError) -> Void
        ) -> URLSessionTask?
}
