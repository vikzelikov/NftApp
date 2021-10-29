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
}

extension UserViewModel {
    init(user: User) {
        self.id = user.id
        self.login = user.login
        self.email = user.email
    }
}
