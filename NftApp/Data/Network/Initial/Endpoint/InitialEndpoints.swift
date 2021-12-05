//
//  InitialEndpoints.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

struct InitialEndpoints {
    
    static func getInitialEndpoint() -> Endpoint {
        let url = Constant.BASE_URL + "api/initial"
        
        return Endpoint(url: url, method: .get)
    }
    
}
