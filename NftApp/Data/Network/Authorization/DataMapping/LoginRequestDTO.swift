//
//  LoginRequestDTO.swift
//  NftApp
//
//  Created by Yegor on 16.08.2021.
//

import Foundation

struct LoginRequestDTO: EncodableProtocol {
    
    var login: String
    var password: String
    
}
