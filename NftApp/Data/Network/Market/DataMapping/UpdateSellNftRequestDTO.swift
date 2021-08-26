//
//  UpdateNftRequestDTO.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

class UpdateSellNftRequestDTO: Decodable {
    private var price: Double
    
    lazy var parameters = [
        "price": price
    ] as [String : Any]

    init(price: Double) {
        self.price = price
    }
}
