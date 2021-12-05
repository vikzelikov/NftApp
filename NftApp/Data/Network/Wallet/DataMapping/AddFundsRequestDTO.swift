//
//  WithdrawFundsRequestDTO.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

struct AddFundsRequestDTO: EncodableProtocol {
    
    var userId: Int
    var orderId: String
    var productIdentifier: String
    var amount: String
    var locale: String
    var hash: String
    
}
