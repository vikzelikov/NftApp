//
//  GetNftsResponseDTO.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

class GetNftsResponseDTO: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case rows
    }
    
    let rows: [NftDTO]
    
}
