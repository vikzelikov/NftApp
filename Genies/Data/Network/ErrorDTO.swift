//
//  ErrorDTO.swift
//  Genies
//
//  Created by Yegor on 18.08.2021.
//

import Foundation

struct ErrorDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case message
    }
    
    let message: String
}
