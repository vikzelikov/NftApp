//
//  MarketUseCase.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

protocol MarketUseCase {
    
    func createSellNft(request: CreateSellNftRequest, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func updateSellNft(request: UpdateSellNftRequest, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func cancelSellNft(nftId: Int, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func getMarketNfts(request: GetMarketNftsRequest, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func buyNft(nftId: Int, completion: @escaping (Result<Bool, Error>) -> Void)
            
}

final class MarketUseCaseImpl: MarketUseCase {
    
    private let repository: MarketRepository?
    
    init() {
        self.repository = MarketRepositoryImpl()
    }
    
    func createSellNft(request: CreateSellNftRequest, completion: @escaping (Result<Bool, Error>) -> Void) {

        repository?.createSellNft(request: request, completion: { result in
            switch result {
            case .success(let resp) : do {
                print("success \(resp)")
            }
            
            case .failure(let error) : do {
                completion(.failure(error))
            }
            }
        })
    }
    
    func updateSellNft(request: UpdateSellNftRequest, completion: @escaping (Result<Bool, Error>) -> Void) {

        repository?.updateSellNft(request: request, completion: { result in
            switch result {
            case .success(let resp) : do {
                print("success \(resp)")
            }
            
            case .failure(let error) : do {
                completion(.failure(error))
            }
            }
        })
    }
    
    func cancelSellNft(nftId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {

        repository?.cancelSellNft(nftId: nftId, completion: { result in
            switch result {
            case .success(let resp) : do {
                print("success \(resp)")
            }
            
            case .failure(let error) : do {
                completion(.failure(error))
            }
            }
        })
    }
    
    func getMarketNfts(request: GetMarketNftsRequest, completion: @escaping (Result<Bool, Error>) -> Void) {

        repository?.getMarketNfts(request: request, completion: { result in
            switch result {
            case .success(let resp) : do {
                print("success \(resp)")
            }
            
            case .failure(let error) : do {
                completion(.failure(error))
            }
            }
        })
    }
    
    func buyNft(nftId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {

        repository?.buyNft(nftId: nftId, completion: { result in
            switch result {
            case .success(let resp) : do {
                print("success \(resp)")
            }
            
            case .failure(let error) : do {
                completion(.failure(error))
            }
            }
        })
    }
    
}

struct CreateSellNftRequest {
    
    var nftId: Int
    var price: Double
    
}

struct UpdateSellNftRequest {
    
    var nftId: Int
    var price: Double
    
}

struct GetMarketNftsRequest {
    
    var page: Int
    
}
