//
//  SearchRequestDTO.swift
//  NftApp
//
//  Created by Yegor on 05.11.2021.
//

import Foundation

class SearchRequestDTO: Decodable {
    private var keyWord: String
    
    lazy var parameters = [
        "keyWord": keyWord
    ] as [String : Any]

    init(keyWord: String) {
        self.keyWord = keyWord
    }
    
}
