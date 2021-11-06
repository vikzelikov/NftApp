//
//  DropShopRepository.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

protocol DropShopRepository {
    
    func getEditions(request: GetEditionsRequest, completion: @escaping (Result<GetEditionsResponseDTO, Error>) -> Void)
    
    func getEdition(editionId: Int, completion: @escaping (Result<EditionDTO, Error>) -> Void)
    
    func buyNft(editionId: Int, completion: @escaping (Result<BuyNftResponseDTO, Error>) -> Void)
    
}
