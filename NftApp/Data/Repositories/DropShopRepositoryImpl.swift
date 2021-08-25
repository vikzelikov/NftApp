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
        
        guard let url = endpoint.url else {
            completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil)))
            return
        }
        
        AF.request(url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func buyNft(request: BuyNftRequest, completion: @escaping (Result<BuyNftResponseDTO, Error>) -> Void) {

        let endpoint = DropShopEndpoints.buyNftEndpoint(request: request)
        
        guard let url = endpoint.url else {
            completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil)))
            return
        }
        
        AF.request(url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
}
