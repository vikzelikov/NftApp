//
//  CommonDTO.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

struct CommonDTO: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case message
    }
    
    let message: String?
    
}
