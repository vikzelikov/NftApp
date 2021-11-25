//
//  Transaction.swift
//  NftApp
//
//  Created by Yegor on 03.11.2021.
//

import Foundation

struct Transaction: Equatable {
    let id: Int
    let fromUserId: Int?
    let toUserId: Int?
    let type: Int
    let amount: Double
    let destination: String?
    let blockchainTransactionId: String?
    let editionId: Int?
    let date: String
}
