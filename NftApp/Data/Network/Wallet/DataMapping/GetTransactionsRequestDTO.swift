//
//  GetTransactionsRequestDTO.swift
//  NftApp
//
//  Created by Yegor on 03.11.2021.
//

import Foundation

class GetTransactionsRequestDTO: Decodable {
    private var page: Int
    
    lazy var parameters = [
        "page": page
    ] as [String : Any]

    init(page: Int) {
        self.page = page
    }
}
