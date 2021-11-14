//
//  User.swift
//  NftApp
//
//  Created by Yegor on 15.08.2021.
//

import Foundation

struct User: Equatable, Identifiable {
    var id: Int
    var login: String?
    var email: String?
    var flowAddress: String?
    var avatarUrl: String?
    var balance: Double?
    var totalCost: Double?
    var oldPassword: String?
    var newPassword: String?
}

struct UserObject {
    static var user: Observable<UserViewModel?> = Observable(nil)
}
