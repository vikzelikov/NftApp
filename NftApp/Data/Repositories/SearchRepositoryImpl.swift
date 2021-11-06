//
//  SearchRepositoryImpl.swift
//  NftApp
//
//  Created by Yegor on 05.11.2021.
//

import Foundation
import Alamofire

class SearchRepositoryImpl: SearchRepository {
    
    func searchUsers(keyWord: String, completion: @escaping (Result<GetUsersResponseDTO, Error>) -> Void) {
        let endpoint = SearchEndpoints.searchUsersEndpoint(keyWord: keyWord)

        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func searchEditions(keyWord: String, completion: @escaping (Result<GetEditionsResponseDTO, Error>) -> Void) {
        let endpoint = SearchEndpoints.searchEditionsEndpoint(keyWord: keyWord)

        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func searchNfts(keyWord: String, completion: @escaping (Result<GetNftsResponseDTO, Error>) -> Void) {
        let endpoint = SearchEndpoints.searchNftsEndpoint(keyWord: keyWord)

        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
}
