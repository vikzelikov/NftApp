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
        case marketFee
        case isAppAvailable
        case isDropshopAvailable
        case isMarketAvailable
        case isDepositAvailable
        case isWithdrawAvailable
        case isInvited
        case isEarlyAccess
    }
    
    let id: Int
    let tokenCurrency: Double
    let marketFee: Double
    let isAppAvailable: Bool
    let isDropshopAvailable: Bool
    let isMarketAvailable: Bool
    let isDepositAvailable: Bool
    let isWithdrawAvailable: Bool
    let isInvited: Bool
    let isEarlyAccess: Bool
}
