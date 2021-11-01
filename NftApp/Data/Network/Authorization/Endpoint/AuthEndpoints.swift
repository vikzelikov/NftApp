//
//  AuthEndpoints.swift
//  NftApp
//
//  Created by Yegor on 16.08.2021.
//

import Foundation
import Alamofire

struct AuthEndpoints {
    
    static func getSignupEndpoint(request: SignupRequest) -> Endpoint {
        let requestDTO = SignupRequestDTO (
            login: request.login,
            email: request.email,
            password: request.password
        ).parameters
        
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = Constant.BASE_URL + "api/auth/registration"
        
        return Endpoint(url: url, method: .post, headers: headers, data: requestDTO)
    }
    
    static func getLoginEndpoint(request: LoginRequest) -> Endpoint {
        let requestDTO = LoginRequestDTO (
            login: request.login,
            password: request.password
        ).parameters
        
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = Constant.BASE_URL + "api/auth/login"
        
        return Endpoint(url: url, method: .post, headers: headers, data: requestDTO)
    }
    
}
