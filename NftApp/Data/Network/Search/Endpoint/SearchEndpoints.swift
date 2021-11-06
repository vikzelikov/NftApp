//
//  SearchEndpoints.swift
//  NftApp
//
//  Created by Yegor on 05.11.2021.
//

import Foundation
import Alamofire

struct SearchEndpoints {
    
    static func searchUsersEndpoint(keyWord: String) -> Endpoint {
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = Constant.BASE_URL + "api/search/users/\(keyWord)"
        
        return Endpoint(url: url, method: .get, headers: headers, data: nil)
    }
    
    static func searchEditionsEndpoint(keyWord: String) -> Endpoint {
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = Constant.BASE_URL + "api/search/editions/\(keyWord)"
        
        return Endpoint(url: url, method: .get, headers: headers, data: nil)
    }
    
    static func searchNftsEndpoint(keyWord: String) -> Endpoint {
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = Constant.BASE_URL + "api/search/nfts/\(keyWord)"
        
        return Endpoint(url: url, method: .get, headers: headers, data: nil)
    }
    
}
