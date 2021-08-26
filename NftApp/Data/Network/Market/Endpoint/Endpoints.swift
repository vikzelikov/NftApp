//
//  File.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation
import Alamofire

struct MarketEndpoints {
    
    static func createSellNft(request: CreateSellNftRequest) -> Endpoint {
        let requestDTO = CreateSellNftRequestDTO (
            price: request.price
        ).parameters
        
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "/api")
        
        return Endpoint(url: url, method: .post, headers: headers, data: requestDTO)
    }
    
    static func updateSellNft(request: UpdateSellNftRequest) -> Endpoint {
        let requestDTO = UpdateSellNftRequestDTO (
            price: request.price
        ).parameters
        
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "/api")
        
        return Endpoint(url: url, method: .post, headers: headers, data: requestDTO)
    }
    
    static func cancelSellNft(nftId: Int) -> Endpoint {
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "/api")
        
        return Endpoint(url: url, method: .post, headers: headers, data: nil)
    }
    
    static func getMarketNfts(request: GetMarketNftsRequest) -> Endpoint {
        let requestDTO = GetMarketNftsRequestDTO (
            page: request.page
        ).parameters
        
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "/api")
        
        return Endpoint(url: url, method: .post, headers: headers, data: requestDTO)
    }
    
    static func buyNft(nftId: Int) -> Endpoint {
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "/api")
        
        return Endpoint(url: url, method: .post, headers: headers, data: nil)
    }
    
}
