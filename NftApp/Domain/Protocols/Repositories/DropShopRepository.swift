//
//  DropShopRepository.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

protocol DropShopRepository {
    
    func getEditions(request: GetEditionsRequest, completion: @escaping (Result<GetEditionsResponseDTO, Error>) -> Void)
    
    func buyNft(request: BuyNftRequest, completion: @escaping (Result<BuyNftResponseDTO, Error>) -> Void)
    
}
