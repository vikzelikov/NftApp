//
//  AuthEndpoints.swift
//  Genies
//
//  Created by Yegor on 16.08.2021.
//

import Foundation
import Alamofire

struct AuthEndpoints {
    
    static func getSignupEndpoint() -> Endpoint {
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "/api/auth/signup")
        
        return Endpoint(url: url, method: .post, headers: headers)
    }
    
    static func getLoginEndpoint() -> Endpoint {
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "/api/auth/login")
        
        return Endpoint(url: url, method: .post, headers: headers)
    }
    
    static func getAuthCheckEndpoint() -> Endpoint {
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "/api/auth/check")
        
        return Endpoint(url: url, method: .post, headers: headers)
    }
    
}
