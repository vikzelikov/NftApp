//
//  NftEdition.swift
//  NftApp
//
//  Created by Yegor on 20.09.2021.
//

import Foundation

struct Edition: Equatable {
    var id: Int
    var influencerId: Int
    var count: Int
    var name: String
    var description: String
    var price: Double
    var dateExpiration: String
    var mediaUrl: String
    var countNFTs: Int
    var influencer: EditionInfluencer
}

struct EditionInfluencer: Equatable {
    var id: Int
    var user: EditionUser
}

struct EditionUser: Equatable {
    var id: Int
    var login: String
    var avatarUrl: String?
}
