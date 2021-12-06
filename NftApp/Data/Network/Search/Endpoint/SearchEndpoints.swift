//
//  SearchEndpoints.swift
//  NftApp
//
//  Created by Yegor on 05.11.2021.
//

import Foundation

struct SearchEndpoints {
    
    static func searchUsersEndpoint(keyWord: String) -> Endpoint {
        let keyWord = keyWord.replacingOccurrences(of: " ", with: "+")
        let url = Constant.BASE_URL + "api/search/users/\(keyWord)"
        
        return Endpoint(url: url, method: .get)
    }
    
    static func searchEditionsEndpoint(keyWord: String) -> Endpoint {
        let keyWord = keyWord.replacingOccurrences(of: " ", with: "+")
        let url = Constant.BASE_URL + "api/search/editions/\(keyWord)"
        
        return Endpoint(url: url, method: .get)
    }
    
    static func searchNftsEndpoint(keyWord: String) -> Endpoint {
        let keyWord = keyWord.replacingOccurrences(of: " ", with: "+")
        let url = Constant.BASE_URL + "api/search/nfts/\(keyWord)"
        
        return Endpoint(url: url, method: .get)
    }
    
}
