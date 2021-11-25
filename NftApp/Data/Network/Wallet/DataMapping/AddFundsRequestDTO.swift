//
//  WithdrawFundsRequestDTO.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

class AddFundsRequestDTO: Decodable {
    private var userId: Int
    private var orderId: String
    private var productIdentifier: String
    private var amount: String
    private var locale: String
    private var hash: String
    
    lazy var parameters = [
        "userId": userId,
        "orderId": orderId,
        "productIdentifier": productIdentifier,
        "amount": amount,
        "locale": locale,
        "hash": hash
    ] as [String : Any]

    init(userId: Int, orderId: String, productIdentifier: String, amount: String, locale: String, hash: String) {
        self.userId = userId
        self.orderId = orderId
        self.productIdentifier = productIdentifier
        self.amount = amount
        self.locale = locale
        self.hash = hash
    }
}
