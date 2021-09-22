//
//  NftExchangeCellViewModel.swift
//  NftApp
//
//  Created by Yegor on 16.07.2021.
//

import Foundation

struct NftCellViewModel {
    var id: Int
    var price: Double
    var serialNumber: Int
    var isForCell: Bool
    var edition: EditionCellViewModel
}

extension NftCellViewModel {
    init(nft: Nft) {
        self.id = nft.id
        self.price = nft.price
        self.serialNumber = nft.serialNumber
        self.isForCell = nft.isForCell
        self.edition = EditionCellViewModel.init(edition: nft.edition)
    }
}
