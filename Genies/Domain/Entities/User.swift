//
//  User.swift
//  Genies
//
//  Created by Yegor on 15.08.2021.
//

import Foundation

struct User: Equatable, Identifiable {
    let id: String?
    let login: String?
    let email: String?
    let password: String?
    let sex: String?
    let birthDate: String?
    let balance: String?
    let influencerId: String?
}
