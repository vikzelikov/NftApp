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
    private var isMale: Bool
    private var birthDate: TimeInterval
    
    lazy var parameters = [
        "login": login,
        "email": email,
        "password": password,
        "is_male": isMale,
        "birth_date": birthDate
    ] as [String : Any]

    init(login: String, email: String, password: String, isMale: Bool, birthDate: TimeInterval) {
        self.login = login
        self.email = email
        self.password = password
        self.isMale = isMale
        self.birthDate = birthDate
    }
}
