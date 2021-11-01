//
//  NFT.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

struct Nft: Equatable {
    var id: Int
    var lastPrice: Double
    let currentPrice: Double?
    var serialNumber: Int
    var isForSell: Bool
    var edition: Edition
}
