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
        let url = URL(string: Constant.BASE_URL + "api/editions")
        
        return Endpoint(url: url, method: .get, headers: headers, data: requestDTO)
    }
    
    static func buyNftEndpoint(editionId: Int) -> Endpoint {
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "api/editions/\(editionId)")
        
        return Endpoint(url: url, method: .post, headers: headers, data: nil)
    }
    
}
