//
//  InitialEndpoints.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation
import Alamofire

struct InitialEndpoints {
    
    static func getInitialEndpoint() -> Endpoint {
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "api/initial")
        
        return Endpoint(url: url, method: .get, headers: headers, data: nil)
    }
}
