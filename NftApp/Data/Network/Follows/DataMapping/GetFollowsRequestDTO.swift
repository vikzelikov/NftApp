//
//  GetFollowsRequestDTO.swift
//  NftApp
//
//  Created by Yegor on 25.09.2021.
//

import Foundation

class GetFollowsRequestDTO {
    
    private var page: Int
        
    lazy var parameters = [
        "page": page
    ] as [String : Any]

    init(page: Int) {
        self.page = page
    }
    
}
