//
//  InitialResponseData.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

struct InitialResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case tokenCurrency
        case marketFee
        case isAppAvailable
        
    }
    
    let tokenCurrency: Int
    let marketFee: Double
    let isAppAvailable: Bool
}
