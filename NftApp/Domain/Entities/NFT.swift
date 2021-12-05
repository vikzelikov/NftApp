//
//  NFT.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

struct Nft {
    
    var id: Int
    var lastPrice: Double
    let currentPrice: Double?
    var serialNumber: Int
    var isForSell: Bool
    var edition: Edition
    
}

extension Nft {
    
    init(nft: NftDTO) {
        self.id = nft.id
        self.lastPrice = nft.lastPrice
        self.currentPrice = nft.currentPrice
        self.serialNumber = nft.serialNumber
        self.isForSell = nft.isForSell
        self.edition = Edition.init(edition: nft.edition)
    }
    
}

extension Nft: Equatable {
    
    static func == (lhs: Nft, rhs: Nft) -> Bool {
        return lhs.id == rhs.id
    }
    
}

struct NftObject {
    
    static var isDropshopNeedRefresh: Observable<Bool> = Observable(false)
    
}
