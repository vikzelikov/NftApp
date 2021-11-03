//
//  DetailTransactionViewModel.swift
//  NftApp
//
//  Created by Yegor on 03.11.2021.
//

import Foundation

protocol DetailTransactionViewModel: BaseViewModel {
    
    var transactionViewModel: Observable<TransactionViewModel?> { get }
    
    func viewDidLoad()
        
}

class DetailTransactionViewModelImpl: DetailTransactionViewModel {
        
    var transactionViewModel: Observable<TransactionViewModel?> = Observable(nil)
    var isLoading: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    func viewDidLoad() {
        
    }
    
}
