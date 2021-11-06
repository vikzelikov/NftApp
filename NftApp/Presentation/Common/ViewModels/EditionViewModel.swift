//
//  EditionCellViewModel.swift
//  NftApp
//
//  Created by Yegor on 20.09.2021.
//

import Foundation

struct EditionViewModel {
    var id: Int
    var influencerId: Int?
    var count: Int?
    var name: String?
    var description: String?
    var price: Double?
    var dateExpiration: String?
    var mediaUrl: String?
    var countNFTs: Int?
}

extension EditionViewModel {
    init(edition: Edition) {
        self.id = edition.id
        self.influencerId = edition.influencerId
        self.count = edition.count
        self.name = edition.name
        self.description = edition.description
        self.price = edition.price
        self.dateExpiration = edition.dateExpiration
        self.mediaUrl = edition.mediaUrl
        self.countNFTs = edition.countNFTs
    }
}
