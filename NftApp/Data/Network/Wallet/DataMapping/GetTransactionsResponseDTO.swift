//
//  GetTransactionsResponseDTO.swift
//  NftApp
//
//  Created by Yegor on 03.11.2021.
//

import Foundation

struct GetTransactionsResponseDTO: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case count
        case rows
    }
    
    let count: Int
    let rows: [TransactionDTO]

}
