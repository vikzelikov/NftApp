//
//  GetNftsRequestDTO.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

class GetNftsRequestDTO: Decodable {
    private var page: Int
    
    lazy var parameters = [
        "page": page
    ] as [String : Any]

    init(page: Int) {
        self.page = page
    }
}
