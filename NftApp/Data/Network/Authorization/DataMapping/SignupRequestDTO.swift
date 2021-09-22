//
//  SignupRequestDTO.swift
//  NftApp
//
//  Created by Yegor on 16.08.2021.
//

import Foundation

class SignupRequestDTO: Decodable {
    private var login: String
    private var email: String
    private var password: String
    
    lazy var parameters = [
        "login": login,
        "email": email,
        "password": password
    ] as [String : Any]

    init(login: String, email: String, password: String) {
        self.login = login
        self.email = email
        self.password = password
    }
}
