//
//  CheckInviteRequestDTO.swift
//  NftApp
//
//  Created by Yegor on 13.11.2021.
//

import Foundation

class CheckInviteRequestDTO: Decodable {
    private var userId: Int
    
    lazy var parameters = [
        "userId": userId
    ] as [String : Int]

    init(userId: Int) {
        self.userId = userId
    }
}
