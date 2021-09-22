//
//  NFT.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

struct Nft: Equatable {
    var id: Int
    var price: Double
    var serialNumber: Int
    var isForCell: Bool
    var edition: NftEdition
}
