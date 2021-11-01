//
//  MarketRepositoryImpl.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation
import Alamofire

class MarketRepositoryImpl: MarketRepository {
    
    func createSellNft(request: CreateSellNftRequest, completion: @escaping (Result<CommonDTO, Error>) -> Void) {
        let endpoint = MarketEndpoints.createSellNft(request: request)
        
        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func updateSellNft(request: UpdateSellNftRequest, completion: @escaping (Result<CommonDTO, Error>) -> Void) {
        let endpoint = MarketEndpoints.updateSellNft(request: request)

        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func cancelSellNft(nftId: Int, completion: @escaping (Result<CommonDTO, Error>) -> Void) {
        let endpoint = MarketEndpoints.cancelSellNft(nftId: nftId)

        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func getMarketNfts(request: GetMarketNftsRequest, completion: @escaping (Result<GetMarketNftsResponseDTO, Error>) -> Void) {
        let endpoint = MarketEndpoints.getMarketNfts(request: request)
        
        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func buyNft(nftId: Int, completion: @escaping (Result<CommonDTO, Error>) -> Void) {
        let endpoint = MarketEndpoints.buyNft(nftId: nftId)

        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
}
