//
//  DropShopRepositoryImpl.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

class DropShopRepositoryImpl: DropShopRepository {
    
    func getEditions(request: GetEditionsRequest, completion: @escaping (Result<GetEditionsResponseDTO, Error>) -> Void) {
        let endpoint = DropShopEndpoints.getEditionsEndpoint(request: request)
        
        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
    func getEdition(editionId: Int, completion: @escaping (Result<EditionDTO, Error>) -> Void) {
        let endpoint = DropShopEndpoints.getEditionEndpoint(editionId: editionId)
        
        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
    func buyNft(editionId: Int, completion: @escaping (Result<BuyNftResponseDTO, Error>) -> Void) {
        let endpoint = DropShopEndpoints.buyNftEndpoint(editionId: editionId)
        
        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
}
