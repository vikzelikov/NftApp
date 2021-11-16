//
//  AuthEndpoints.swift
//  NftApp
//
//  Created by Yegor on 16.08.2021.
//

import Foundation
import Alamofire

struct AuthEndpoints {
    
    static func signupEndpoint(request: SignupRequest) -> Endpoint {
        let requestDTO = SignupRequestDTO (
            login: request.login,
            email: request.email,
            password: request.password
        ).parameters
        
        let url = Constant.BASE_URL + "api/auth/registration"
        
        return Endpoint(url: url, method: .post, headers: [], data: requestDTO)
    }
    
    static func getLoginEndpoint(request: LoginRequest) -> Endpoint {
        let requestDTO = LoginRequestDTO (
            login: request.login,
            password: request.password
        ).parameters
        
        let url = Constant.BASE_URL + "api/auth/login"
        
        return Endpoint(url: url, method: .post, headers: [], data: requestDTO)
    }
    
    static func appleLoginEndpoint(appleId: String) -> Endpoint {
        let requestDTO = AppleLoginRequestDTO (
            appleId: appleId
        ).parameters
        
        let url = Constant.BASE_URL + "api/auth/appleId"
        
        return Endpoint(url: url, method: .post, headers: [], data: requestDTO)
    }
    
    static func checkInviteEndpoint(inviteWord: String) -> Endpoint {
        let requestDTO = CheckInviteRequestDTO (
            userId: Constant.USER_ID
        ).parameters
        
        let url = Constant.BASE_URL + "api/auth/\(inviteWord)"
        
        return Endpoint(url: url, method: .post, headers: [], data: requestDTO)
    }
    
}
