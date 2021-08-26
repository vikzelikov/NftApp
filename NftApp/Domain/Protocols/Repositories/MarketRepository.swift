//
//  MarketRepository.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

protocol MarketRepository {
    
    func createSellNft(request: CreateSellNftRequest, completion: @escaping (Result<CommonDTO, Error>) -> Void)
    
    func updateSellNft(request: UpdateSellNftRequest, completion: @escaping (Result<CommonDTO, Error>) -> Void)
    
    func cancelSellNft(nftId: Int, completion: @escaping (Result<CommonDTO, Error>) -> Void)
    
    func getMarketNfts(request: GetMarketNftsRequest, completion: @escaping (Result<GetMarketNftsResponseDTO, Error>) -> Void)
    
    func buyNft(nftId: Int, completion: @escaping (Result<CommonDTO, Error>) -> Void)
    
}
