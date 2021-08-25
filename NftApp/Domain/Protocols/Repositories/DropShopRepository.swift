//
//  DropShopRepository.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

protocol DropShopRepository {
    
    func getNfts(request: GetNftsRequest, completion: @escaping (Result<GetNftsResponseDTO, Error>) -> Void)
    
    func buyNft(request: BuyNftRequest, completion: @escaping (Result<BuyNftResponseDTO, Error>) -> Void)
    
}
