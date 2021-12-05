//
//  GetNftsRequestDTO.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

class GetEditionsRequestDTO {
    
    private var page: Int
    private var type: String
        
    lazy var parameters = [
        "page": page,
        "type": type
    ] as [String : Any]

    init(page: Int, type: String) {
        self.page = page
        self.type = type
    }
    
}
