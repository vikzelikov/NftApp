//
//  File.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

struct MarketEndpoints {
    
    static func createSellNft(request: CreateSellNftRequest) -> Endpoint {
        let requestDTO = CreateSellNftRequestDTO(
            price: request.price
        )
        
        let url = Constant.BASE_URL + "/api"
        
        return Endpoint(url: url, method: .post, bodyParameters: requestDTO)
    }
    
    static func updateSellNft(request: UpdateSellNftRequest) -> Endpoint {
        let requestDTO = UpdateSellNftRequestDTO(
            price: request.price
        )
        
        let url = Constant.BASE_URL + "/api"
        
        return Endpoint(url: url, method: .post, bodyParameters: requestDTO)
    }
    
    static func cancelSellNft(nftId: Int) -> Endpoint {
        let url = Constant.BASE_URL + "/api"
        
        return Endpoint(url: url, method: .post)
    }
    
    static func getMarketNfts(request: GetMarketNftsRequest) -> Endpoint {
        let url = Constant.BASE_URL + "/api"
        
        return Endpoint(url: url, method: .post)
    }
    
    static func buyNft(nftId: Int) -> Endpoint {
        let url = Constant.BASE_URL + "/api"
        
        return Endpoint(url: url, method: .post)
    }
    
}
