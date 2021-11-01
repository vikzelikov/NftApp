//
//  NetworkHelper.swift
//  NftApp
//
//  Created by Yegor on 16.08.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

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
    static let notFound = 404
    static let internalServerError = 500
}

struct NetworkHelper {
    
    static let TIMEOUT: Double = 5
    
    static func getHeaders() -> HTTPHeaders {
        return [
            "Authorization": "Bearer " + Constant.AUTH_TOKEN,
            "Accept": "application/json"
        ]
    }
    
    static func validateResponse<T : Decodable>(response: AFDataResponse<String>,
                                 completion: @escaping (Result<T, Error>) -> Void) {

        guard let resp = response.response else {
            completion(.failure(ErrorMessage(errorType: .error, errorDTO: nil, code: nil)))
            return
        }
        
        guard let data = response.data else {
            completion(.failure(ErrorMessage(errorType: .error, errorDTO: nil, code: resp.statusCode)))
            return
        }
        
        if response.error != nil {
            if let errorDTO = try? JSONDecoder().decode(ErrorDTO.self, from: data) {
                let error = ErrorMessage(errorType: .error, errorDTO: errorDTO, code: resp.statusCode)
                print(error)
                completion(.failure(error))
                return
            } else {
                completion(.failure(ErrorMessage(errorType: .error, errorDTO: nil, code: resp.statusCode)))
                return
            }
        }
        
//        print(T.self)
//        var json = JSON(data)
//        print(json)
        
        if let responseDTO = try? JSONDecoder().decode(T.self, from: data) {
            completion(.success(responseDTO))
        } else {
            print("пизда \(resp.statusCode)")
            completion(.failure(ErrorMessage(errorType: .error, errorDTO: nil, code: resp.statusCode)))
        }
        
    }
    
    static func validateBoolResponse(response: AFDataResponse<String>,
                                 completion: @escaping (Result<Bool, Error>) -> Void) {
        
        guard let resp = response.response else {
            completion(.failure(ErrorMessage(errorType: .error, errorDTO: nil, code: nil)))
            return
        }
        
        guard let data = response.data else {
            completion(.failure(ErrorMessage(errorType: .error, errorDTO: nil, code: resp.statusCode)))
            return
        }
        
        if response.error != nil {
            if let errorDTO = try? JSONDecoder().decode(ErrorDTO.self, from: data) {
                let error = ErrorMessage(errorType: .error, errorDTO: errorDTO, code: resp.statusCode)
                print(error)
                completion(.failure(error))
                return
            } else {
                completion(.failure(ErrorMessage(errorType: .error, errorDTO: nil, code: resp.statusCode)))
                return
            }
        } else {
            completion(.success(true))
        }
    }
}
