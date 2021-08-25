//
//  BuyNftRequestDTO.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

class BuyNftRequestDTO: Decodable {
    private var userId: Int
    private var editionId: Int
    
    lazy var parameters = [
        "userID": userId,
        "editionID": editionId
    ] as [String : Any]

    init(userId: Int, editionId: Int) {
        self.userId = userId
        self.editionId = editionId
    }
    
}
