//
//  ErrorDTO.swift
//  NftApp
//
//  Created by Yegor on 18.08.2021.
//

import Foundation

struct ErrorDTO: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case statusCode
        case message
    }
    
    let statusCode: Int
    let message: String
    
}
