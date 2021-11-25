//
//  TransactionCellViewModel.swift
//  NftApp
//
//  Created by Yegor on 01.08.2021.
//

import Foundation

struct TransactionViewModel {
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

extension TransactionViewModel {
    init(transactions: Transaction) {
        self.id = transactions.id
        self.fromUserId = transactions.fromUserId
        self.toUserId = transactions.toUserId
        self.type = transactions.type
        self.amount = transactions.amount
        self.destination = transactions.destination
        self.blockchainTransactionId = transactions.blockchainTransactionId
        self.editionId = transactions.editionId
        self.date = transactions.date
    }
}
