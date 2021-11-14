//
//  CheckInviteRequestDTO.swift
//  NftApp
//
//  Created by Yegor on 13.11.2021.
//

import Foundation

class CheckInviteRequestDTO: Decodable {
    private var userId: Int
    private var inviteWord: String
    
    lazy var parameters = [
        "userId": userId,
        "inviteWord": inviteWord
    ] as [String : Any]

    init(userId: Int, inviteWord: String) {
        self.userId = userId
        self.inviteWord = inviteWord
    }
}
