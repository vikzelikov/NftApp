//
//  DropShopEndpoints.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

struct DropShopEndpoints {
    
    static func getEditionsEndpoint(request: GetEditionsRequest) -> Endpoint {
        let requestDTO = GetEditionsRequestDTO (
            page: request.page,
            type: "dropshop"
        ).parameters
        
        let url = Constant.BASE_URL + "api/editions"
        
        return Endpoint(url: url, method: .get, urlParameters: requestDTO)
    }
    
    static func getEditionEndpoint(editionId: Int) -> Endpoint {
        let url = Constant.BASE_URL + "api/editions/\(editionId)"
        
        return Endpoint(url: url, method: .get)
    }
    
    static func buyNftEndpoint(editionId: Int) -> Endpoint {
        let url = Constant.BASE_URL + "api/editions/\(editionId)"
        
        return Endpoint(url: url, method: .post)
    }
    
}
