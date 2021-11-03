//
//  TransactionDTO.swift
//  NftApp
//
//  Created by Yegor on 03.11.2021.
//

import Foundation

class TransactionDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case fromUserId
        case toUserId
        case type
        case amount
        case destination
        case blockchainTransactionId
        case nftId
        case createdAt
    }
    
    let id: Int
    let fromUserId: Int
    let toUserId: Int
    let type: Int
    let amount: Double
    let destination: String?
    let blockchainTransactionId: String?
    let nftId: Int?
    let createdAt: String
}
