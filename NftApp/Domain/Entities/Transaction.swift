//
//  Transaction.swift
//  NftApp
//
//  Created by Yegor on 03.11.2021.
//

import Foundation

struct Transaction {
    
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

extension Transaction {
    
    init(transaction: TransactionDTO) {
        self.id = transaction.id
        self.fromUserId = transaction.fromUserId
        self.toUserId = transaction.toUserId
        self.type = transaction.type
        self.amount = transaction.amount
        self.destination = transaction.destination
        self.blockchainTransactionId = transaction.blockchainTransactionId
        self.editionId = transaction.nft?.edition?.id
        self.date = transaction.createdAt
    }
    
}

extension Transaction: Equatable {
    
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.id == rhs.id
    }
    
}
