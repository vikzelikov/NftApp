//
//  UserEndpoints.swift
//  Genies
//
//  Created by Yegor on 20.08.2021.
//

import Foundation

import Foundation
import Alamofire

struct UserEndpoints {
    
    static func getUserEndpoint(userId: Int) -> Endpoint {
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "/users/\(userId)")
        
        return Endpoint(url: url, method: .get, headers: headers, data: nil)
    }
    
}
