//
//  DropShopEndpoints.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation
import Alamofire

struct DropShopEndpoints {
    
    static func getEditionsEndpoint(request: GetEditionsRequest) -> Endpoint {
        let requestDTO = GetEditionsRequestDTO (
            page: request.page
        ).parameters
        
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "/api")
        
        return Endpoint(url: url, method: .post, headers: headers, data: requestDTO)
    }
    
    static func buyNftEndpoint(request: BuyNftRequest) -> Endpoint {
        let requestDTO = BuyNftRequestDTO (
            userId: request.userId,
            editionId: request.editionId
        ).parameters
        
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "/api")
        
        return Endpoint(url: url, method: .post, headers: headers, data: requestDTO)
    }
    
}
