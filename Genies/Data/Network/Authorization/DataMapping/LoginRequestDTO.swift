//
//  LoginRequestDTO.swift
//  Genies
//
//  Created by Yegor on 16.08.2021.
//

import Foundation

class LoginRequestDTO: Decodable {
    private var login: String
    private var password: String
    
    lazy var parameters = [
        "login": login,
        "password": password,
    ]

    init(login: String, password: String) {
        self.login = login
        self.password = password
    }
}
