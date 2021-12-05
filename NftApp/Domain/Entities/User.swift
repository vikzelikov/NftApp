//
//  User.swift
//  NftApp
//
//  Created by Yegor on 15.08.2021.
//

import Foundation

struct User {
    
    var id: Int
    var influencerId: Int?
    var login: String?
    var email: String?
    var flowAddress: String?
    var avatarUrl: String?
    var balance: Double?
    var totalCost: Double?
    var countNFTs: Int?
    var oldPassword: String?
    var newPassword: String?
    var inviteWord: String?
    var publicKey: String?
    
}

extension User {
    
    init(user: UserDTO) {
        self.id = user.id
        self.influencerId = user.influencerId
        self.login = user.login
        self.email = user.email
        self.flowAddress = user.flowAddress
        self.avatarUrl = user.avatarUrl
        self.balance = Double(user.balance ?? "0.0")
        self.totalCost = Double(user.totalCost ?? 0)
        self.countNFTs = user.countNFTs
        self.inviteWord = user.inviteWord
        self.publicKey = user.publicKey
    }
    
}


extension User: Equatable {
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
}

struct UserObject {
    
    static var isNeedRefresh: Observable<Bool> = Observable(false)
    static var user: Observable<User?> = Observable(nil)
    
}
