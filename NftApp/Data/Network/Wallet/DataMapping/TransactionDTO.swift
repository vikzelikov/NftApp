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
        case nft
        case createdAt
    }
    
    let id: Int
    let fromUserId: Int?
    let toUserId: Int?
    let type: Int
    let amount: Double
    let destination: String?
    let blockchainTransactionId: String?
    let nft: TransactionNftDTO?
    let createdAt: String
}

class TransactionNftDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case edition
    }
    
    let id: Int
    let edition: TransactionEditionDTO?
}

class TransactionEditionDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
    }
    
    let id: Int
}
