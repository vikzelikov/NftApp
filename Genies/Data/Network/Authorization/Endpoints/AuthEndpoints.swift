//
//  AuthEndpoints.swift
//  Genies
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
            password: request.password,
            isMale: request.isMale,
            birthDate: request.birthDate
        ).parameters
        
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "/auth/registration")
        
        return Endpoint(url: url, method: .post, headers: headers, data: requestDTO)
    }
    
    static func getLoginEndpoint(request: LoginRequest) -> Endpoint {
        let requestDTO = LoginRequestDTO (
            login: request.login,
            password: request.password
        ).parameters
        
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "/api/auth/login")
        
        return Endpoint(url: url, method: .post, headers: headers, data: requestDTO)
    }
    
    static func getAuthCheckEndpoint(request: LoginRequest) -> Endpoint {
        let requestDTO = LoginRequestDTO (
            login: request.login,
            password: request.password
        ).parameters
        
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "/api/auth/check")
        
        return Endpoint(url: url, method: .post, headers: headers, data: requestDTO)
    }
    
}
