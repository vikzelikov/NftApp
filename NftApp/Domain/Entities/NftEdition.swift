//
//  NftEdition.swift
//  NftApp
//
//  Created by Yegor on 20.09.2021.
//

import Foundation

struct NftEdition: Equatable {
    let id: Int
    let influencerId: Int
    let count: Int
    let name: String
    let description: String
    let date: TimeInterval
    let price: Double
    let dateExpiration: TimeInterval
    let mediaUrl: String
}
