//
//  UpdateUserRequestDTO.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

class UpdateUserRequestDTO: Decodable {
    
    lazy var parameters = [
        "id": Constant.USER_ID
    ] as [String : Any]

    init() { }
    
}
