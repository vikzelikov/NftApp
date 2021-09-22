//
//  DetailNftViewModel.swift
//  NftApp
//
//  Created by Yegor on 22.09.2021.
//

import Foundation

protocol DetailNftViewModel : BaseViewModel {
    
    var nftViewModel: Observable<NftCellViewModel?> { get }
    
}

class DetailNftViewModelImpl: DetailNftViewModel {
    
    var nftViewModel: Observable<NftCellViewModel?> = Observable(nil)
    var isLoading: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
}
    
