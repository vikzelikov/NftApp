//
//  LoginAppleRequestDTO.swift
//  NftApp
//
//  Created by Yegor on 05.11.2021.
//

import Foundation

class AppleLoginRequestDTO: Decodable {
    private var appleId: String
    
    lazy var parameters = [
        "appleId": appleId
    ]

    init(appleId: String) {
        self.appleId = appleId
    }
}
