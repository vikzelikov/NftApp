//
//  WithdrawFundsRequestDTO.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

class WithdrawFundsRequestDTO: Decodable {
    private var amount: Double
    
    lazy var parameters = [
        "amount": amount
    ] as [String : Any]

    init(amount: Double) {
        self.amount = amount
    }
}
