//
//  SearchCellViewModel.swift
//  NftApp
//
//  Created by Yegor on 05.11.2021.
//

import Foundation

struct SearchCellViewModel {
    
    var id: Int
    var title: String
    var subtitle: String?
    var mediaUrl: String?
    var type: TypeSearch
    
}

extension SearchCellViewModel: Hashable {
    
    static func == (lhs: SearchCellViewModel, rhs: SearchCellViewModel) -> Bool {
        return lhs.id == rhs.id && lhs.type == rhs.type
    }
    
}
