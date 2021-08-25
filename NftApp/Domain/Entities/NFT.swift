//
//  NFT.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

struct NFT: Equatable, Identifiable {
    var id: Int
    var metadata: NftMetadata
}
