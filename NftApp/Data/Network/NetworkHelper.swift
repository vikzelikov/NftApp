//
//  NetworkHelper.swift
//  NftApp
//
//  Created by Yegor on 16.08.2021.
//

import Foundation
import Alamofire

enum NetworkError {
    case error
    case notConnected
    case cancelled
}

struct ErrorMessage: Error {
    var errorType: NetworkError
    var errorDTO: ErrorDTO?
    var code: Int?
}

struct HttpCode {
    static let ok = 200
    static let badRequest = 400
    static let unauthorized = 401
    static let internalServerError = 500
}

struct NetworkHelper {
    
    static func getHeaders() -> HTTPHeaders {
        return [
            "Authorization": "Bearer " + Constant.AUTH_TOKEN,
            "Accept": "application/json"
        ]
    }
    
}
