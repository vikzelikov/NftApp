//
//  SearchRepositoryImpl.swift
//  NftApp
//
//  Created by Yegor on 05.11.2021.
//

import Foundation

class SearchRepositoryImpl: SearchRepository {
    
    func searchUsers(keyWord: String, completion: @escaping (Result<GetUsersResponseDTO, Error>) -> Void) {
        let endpoint = SearchEndpoints.searchUsersEndpoint(keyWord: keyWord)

        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
    func searchEditions(keyWord: String, completion: @escaping (Result<GetEditionsResponseDTO, Error>) -> Void) {
        let endpoint = SearchEndpoints.searchEditionsEndpoint(keyWord: keyWord)

        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
    func searchNfts(keyWord: String, completion: @escaping (Result<GetNftsResponseDTO, Error>) -> Void) {
        let endpoint = SearchEndpoints.searchNftsEndpoint(keyWord: keyWord)

        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
}
