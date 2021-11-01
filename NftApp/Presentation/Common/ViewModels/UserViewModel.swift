//
//  UserCellViewModel.swift
//  NftApp
//
//  Created by Yegor on 27.09.2021.
//

import Foundation

struct UserViewModel {
    var id: Int
    var login: String
    var email: String
    var flowAddress: String?
    var avatarUrl: String?
}

extension UserViewModel {
    init(user: User) {
        self.id = user.id
        self.login = user.login
        self.email = user.email
        self.flowAddress = user.flowAddress
        self.avatarUrl = user.avatarUrl
    }
}
