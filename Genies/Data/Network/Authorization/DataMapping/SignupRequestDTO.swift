//
//  SignupRequestDTO.swift
//  Genies
//
//  Created by Yegor on 16.08.2021.
//

import Foundation

class SignupRequestDTO {
    private var login: String
    private var email: String
    private var password: String
    private var sex: String
    private var birthDate: String
    
    lazy var parameters = [
        "login": login,
        "email": email,
        "password": password,
        "sex": sex,
        "birth_date": birthDate,
        "email": email,
    ]

    init(login: String, email: String, password: String, sex: String, birthDate: String) {
        self.login = login
        self.email = email
        self.password = password
        self.sex = sex
        self.birthDate = birthDate
    }
}
