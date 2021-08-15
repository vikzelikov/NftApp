//
//  NetworkHelper.swift
//  Genies
//
//  Created by Yegor on 16.08.2021.
//

import Foundation
import Alamofire

public enum NetworkError: Error {
    case errorCode(statusCode: Int)
    case notConnected
    case cancelled
    case errorData
}


struct NetworkHelper {
    
    static func getHeaders() -> HTTPHeaders {
        return [
            "Authorization": "Bearer " + Constant.AUTH_TOKEN,
            "Accept": "application/json"
        ]
    }
    
}
