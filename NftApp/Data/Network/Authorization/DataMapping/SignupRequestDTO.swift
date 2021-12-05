//
//  SignupRequestDTO.swift
//  NftApp
//
//  Created by Yegor on 16.08.2021.
//

import Foundation

struct SignupRequestDTO: EncodableProtocol {
    
    var login: String
    var email: String
    var password: String
    
}
