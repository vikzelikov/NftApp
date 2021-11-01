//
//  NftEdition.swift
//  NftApp
//
//  Created by Yegor on 20.09.2021.
//

import Foundation

struct Edition: Equatable {
    let id: Int
    let influencerId: Int
    let count: Int
    let name: String
    let description: String
    let price: Double
    let dateExpiration: String
    let mediaUrl: String
}
