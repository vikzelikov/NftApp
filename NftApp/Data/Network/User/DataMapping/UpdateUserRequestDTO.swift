//
//  UpdateUserRequestDTO.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

class UpdateUserRequestDTO: Decodable {
    private var email: String
    
    lazy var parameters = [
        "email": email
    ] as [String : Any]

    init(email: String) {
        self.email = email
    }
}
