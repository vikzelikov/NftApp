//
//  SearchRepository.swift
//  NftApp
//
//  Created by Yegor on 05.11.2021.
//

import Foundation

protocol SearchRepository {
    
    func searchUsers(keyWord: String, completion: @escaping (Result<GetUsersResponseDTO, Error>) -> Void)
    
    func searchEditions(keyWord: String, completion: @escaping (Result<GetEditionsResponseDTO, Error>) -> Void)
    
    func searchNfts(keyWord: String, completion: @escaping (Result<GetNftsResponseDTO, Error>) -> Void)

}
