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
    var influencer: EditionInfluencerViewModel?
}

struct EditionInfluencerViewModel: Equatable {
    var id: Int
    var user: EditionUserViewModel
}

struct EditionUserViewModel: Equatable {
    var id: Int
    var login: String
    var avatarUrl: String?
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
        
        if let influencer = edition.influencer {
            self.influencer = EditionInfluencerViewModel.init(edition: influencer)
        }
    }
}

extension EditionInfluencerViewModel {
    init(edition: EditionInfluencer) {
        self.id = edition.id
        self.user = EditionUserViewModel.init(edition: edition.user)
    }
}

extension EditionUserViewModel {
    init(edition: EditionUser) {
        self.id = edition.id
        self.login = edition.login
        self.avatarUrl = edition.avatarUrl
    }
}
