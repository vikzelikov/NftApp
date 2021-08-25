//
//  NftMetadata.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

struct NftMetadata: Equatable, Identifiable {
    var id: Int
    var title: String
    var description: String
    var mediaUrl: String
}
