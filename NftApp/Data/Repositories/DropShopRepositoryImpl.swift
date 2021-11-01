//
//  DropShopRepositoryImpl.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation
import Alamofire

class DropShopRepositoryImpl: DropShopRepository {
    
    func getEditions(request: GetEditionsRequest, completion: @escaping (Result<GetEditionsResponseDTO, Error>) -> Void) {
        let endpoint = DropShopEndpoints.getEditionsEndpoint(request: request)
        
        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func buyNft(editionId: Int, completion: @escaping (Result<BuyNftResponseDTO, Error>) -> Void) {
        let endpoint = DropShopEndpoints.buyNftEndpoint(editionId: editionId)
        
        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in

            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
}
