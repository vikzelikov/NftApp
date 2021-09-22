//
//  EditionCellViewModel.swift
//  NftApp
//
//  Created by Yegor on 20.09.2021.
//

import Foundation

struct EditionCellViewModel {
    var id: Int
    var influencerId: Int
    var count: Int
    var name: String
    var description: String
    var date: TimeInterval?
    var price: Double
    var dateExpiration: TimeInterval?
    var mediaUrl: String
}

extension EditionCellViewModel {
    init(edition: NftEdition) {
        self.id = edition.id
        self.influencerId = edition.influencerId
        self.count = edition.count
        self.name = edition.name
        self.description = edition.description
        self.date = edition.date
        self.price = edition.price
        self.dateExpiration = edition.dateExpiration
        self.mediaUrl = edition.mediaUrl
    }
}
