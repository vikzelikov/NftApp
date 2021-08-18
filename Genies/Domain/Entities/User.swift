//
//  User.swift
//  Genies
//
//  Created by Yegor on 15.08.2021.
//

import Foundation

struct User: Equatable, Identifiable {
    let id: Int?
    let login: String?
    let email: String?
    let password: String?
    let isMale: Bool?
    let birthDate: TimeInterval?
    let balance: String?
    let influencerId: String?
}
