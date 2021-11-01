//
//  NftExchangeCellViewModel.swift
//  NftApp
//
//  Created by Yegor on 16.07.2021.
//

import Foundation

struct NftViewModel {
    var id: Int
    var price: Double
    var serialNumber: Int
    var isForCell: Bool
    var edition: EditionViewModel
}

extension NftViewModel {
    init(nft: Nft) {
        self.id = nft.id
        self.price = nft.lastPrice
        self.serialNumber = nft.serialNumber
        self.isForCell = nft.isForSell
        self.edition = EditionViewModel.init(edition: nft.edition)
    }
}
