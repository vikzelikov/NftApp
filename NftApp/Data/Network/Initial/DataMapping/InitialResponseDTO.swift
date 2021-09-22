//
//  InitialResponseData.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

struct InitialResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case tokenCurrency
        case exchangeFee
        case isAppAvailable
        case isDropshopAvailable
        case isMarketAvailable
        case isDepositAvailable
        case isWithdrawAvailable
    }
    
    let id: Int
    let tokenCurrency: Double
    let exchangeFee: Double
    let isAppAvailable: Bool
    let isDropshopAvailable: Bool
    let isMarketAvailable: Bool
    let isDepositAvailable: Bool
    let isWithdrawAvailable: Bool
}
