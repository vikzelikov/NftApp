//
//  InitialData.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

struct InitialData {
    var tokenCurrency: Double
    var marketFee: Double
    var isAppAvailable: Bool
    var isDropShopAvailable: Bool
    var isMarketAvailable: Bool
    var isDepositAvailable: Bool
    var isWithdrawAvailable: Bool
    var isInvited: Bool
    var isEarlyAccess: Bool
}

extension InitialData {
    
    init(data: InitialResponseDTO) {
        self.tokenCurrency = data.tokenCurrency
        self.marketFee = data.marketFee
        self.isAppAvailable = data.isAppAvailable
        self.isDropShopAvailable = data.isDropshopAvailable
        self.isMarketAvailable = data.isMarketAvailable
        self.isDepositAvailable = data.isDepositAvailable
        self.isWithdrawAvailable = data.isWithdrawAvailable
        self.isInvited = data.isInvited
        self.isEarlyAccess = data.isEarlyAccess
    }
    
}

struct InitialDataObject {
    
    static var data: Observable<InitialData?> = Observable(nil)
    
}
