//
//  UserCellViewModel.swift
//  NftApp
//
//  Created by Yegor on 27.09.2021.
//

import Foundation

struct UserViewModel {
    var id: Int
    var influencerId: Int?
    var login: String?
    var email: String?
    var flowAddress: String?
    var avatarUrl: String?
    var balance: Double?
    var totalCost: Double?
}

extension UserViewModel {
    init(user: User) {
        self.id = user.id
        self.influencerId = user.influencerId
        self.login = user.login
        self.email = user.email
        self.flowAddress = user.flowAddress
        self.avatarUrl = user.avatarUrl
        self.balance = user.balance
        self.totalCost = user.totalCost
    }
}
