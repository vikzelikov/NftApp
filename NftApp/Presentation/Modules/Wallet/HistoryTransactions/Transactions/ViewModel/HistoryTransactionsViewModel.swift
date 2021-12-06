//
//  HistoryTransactionsViewModel.swift
//  NftApp
//
//  Created by Yegor on 03.11.2021.
//

import Foundation

protocol HistoryTransactionsViewModel: BaseViewModel {
    
    var items: Observable<[Transaction]> { get }
    
    func viewDidLoad()
    
    func didSelectItem(at index: Int, completion: @escaping (Transaction) -> Void)
    
}

enum TypeTransactions: Int {
    
    case buyTokens = 0
    case withdrawTokens = 1
    case dropshop = 2
    case market = 3
    
}

final class HistoryTransactionsViewModelImpl: HistoryTransactionsViewModel {
    
    private let walletUseCase: WalletUseCase
    
    private var query: String = ""
    private var currentPage: Int = 1
    private var totalPageCount: Int = 1
    var items: Observable<[Transaction]> = Observable([])
    var isLoading: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init(walletUseCase: WalletUseCase = DIContainer.shared.resolve(type: WalletUseCase.self)) {
        self.walletUseCase = walletUseCase
    }
    
    func viewDidLoad() {
        getTransactions()
    }

    private func getTransactions() {
        self.isLoading.value = true
        
        let request = GetTransactionsRequest(page: currentPage)
        
        walletUseCase.getTransactions(request: request, completion: { result in
            switch result {
            case .success(let transactions):
                self.appendTransactions(transactions: transactions)

            case .failure(let error):
                let (httpCode, errorStr) = ErrorHelper.validateError(error: error)
                if httpCode != HTTPCode.notFound {
                    self.errorMessage.value = errorStr
                }
            }

            self.isLoading.value = false
        })
    }
    
    private func appendTransactions(transactions: [Transaction]) {
//        currentPage = page.page
//        totalPageCount = page.totalPages
                
        items.value += transactions
    }
    
    private func resetPages() {
        currentPage = 1
        totalPageCount = 1
        items.value.removeAll()
    }
    
    func didSelectItem(at index: Int, completion: @escaping (Transaction) -> Void) {
        let viewModel = items.value[index]
        
        completion(viewModel)
    }
    
}
