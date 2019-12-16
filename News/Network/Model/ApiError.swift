//
//  ApiError.swift
//  News
//
//  Created by Dima Panchuk on 21.11.2019.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

struct ApiError: Codable {
    let status: String
    let message: String
    let code: String
    
    var description: String {
        return message
    }
}
