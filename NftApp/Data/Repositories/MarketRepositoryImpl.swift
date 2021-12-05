//
//  MarketRepositoryImpl.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

class MarketRepositoryImpl: MarketRepository {
    
    func createSellNft(request: CreateSellNftRequest, completion: @escaping (Result<CommonDTO, Error>) -> Void) {
        let endpoint = MarketEndpoints.createSellNft(request: request)
        
        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
    func updateSellNft(request: UpdateSellNftRequest, completion: @escaping (Result<CommonDTO, Error>) -> Void) {
        let endpoint = MarketEndpoints.updateSellNft(request: request)

        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
    func cancelSellNft(nftId: Int, completion: @escaping (Result<CommonDTO, Error>) -> Void) {
        let endpoint = MarketEndpoints.cancelSellNft(nftId: nftId)

        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
    func getMarketNfts(
        request: GetMarketNftsRequest,
        completion: @escaping (Result<GetMarketNftsResponseDTO, Error>) -> Void
    ) {
        let endpoint = MarketEndpoints.getMarketNfts(request: request)
        
        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
    func buyNft(nftId: Int, completion: @escaping (Result<CommonDTO, Error>) -> Void) {
        let endpoint = MarketEndpoints.buyNft(nftId: nftId)

        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
}
