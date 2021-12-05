//
//  NftEdition.swift
//  NftApp
//
//  Created by Yegor on 20.09.2021.
//

import Foundation

struct Edition {
    
    var id: Int
    var influencerId: Int?
    var count: Int
    var name: String
    var description: String
    var price: Double?
    var dateExpiration: String
    var mediaUrl: String
    var countNFTs: Int
    var influencer: EditionInfluencer?
    
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

extension Edition {
    
    init(edition: EditionDTO) {
        self.id = edition.id
        self.influencerId = edition.influencerId
        self.count = edition.count ?? 0
        self.name = edition.name
        self.description = edition.description
        self.price = edition.price
        self.dateExpiration = edition.dateExpiration ?? ""
        self.mediaUrl = edition.mediaUrl
        self.countNFTs = edition.countNFTs ?? 0
        
        if let influencer = edition.influencer {
            self.influencer = EditionInfluencer.init(edition: influencer)
        }
    }
    
}

extension Edition: Equatable {
    
    static func == (lhs: Edition, rhs: Edition) -> Bool {
        return lhs.id == rhs.id
    }
    
}

extension EditionInfluencer {
    
    init(edition: EditionInfluencerDTO) {
        self.id = edition.id
        self.user = EditionUser.init(edition: edition.user)
    }
    
}

extension EditionUser {
    
    init(edition: EditionUserDTO) {
        self.id = edition.id
        self.login = edition.login
        self.avatarUrl = edition.avatarUrl
    }
    
}
