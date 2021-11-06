//
//  SearchViewModel.swift
//  NftApp
//
//  Created by Yegor on 05.11.2021.
//

import Foundation

protocol SearchViewModel: BaseViewModel {
    
    var items: Observable<[SearchCellViewModel]> { get }
    
    func searchDidTap(keyWord: String)
    
    func didSelectItem(at index: Int, completion: @escaping (SearchCellViewModel) -> Void)
    
}

enum TypeSearch {
    case users
    case editions
    case nfts
    case separator
}

class SearchViewModelImpl: SearchViewModel {
    
    private let searchUseCase: SearchUseCase
    
    var items: Observable<[SearchCellViewModel]> = Observable([])
    var isLoading: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    private var usersItems: [SearchCellViewModel] = []
    private var editionsItems: [SearchCellViewModel] = []
    private var nftsItems: [SearchCellViewModel] = []
    private var isUsersSearched = false
    private var isEditionsSearched = false
    private var isNftsSearched = false
    
    init() {
        searchUseCase = SearchUseCaseImpl()
    }
    
    func searchDidTap(keyWord: String) {
        resetSearch()
        if isSearching() { return }
        isLoading.value = true
        
        let query = keyWord.trimmingCharacters(in: .whitespacesAndNewlines)

        searchUsers(keyWord: query, completion: { _ in
            self.serachDone()
        })
        
        searchEditions(keyWord: query, completion: { _ in
            self.serachDone()
        })
        
        searchNfts(keyWord: query, completion: { _ in
            self.serachDone()
        })
    }
    
    private func searchUsers(keyWord: String, completion: @escaping (Bool) -> Void) {
        searchUseCase.searchUsers(keyWord: keyWord, completion: { result in
            switch result {
            case .success(let items):
                self.usersItems += items

            case .failure(let error):
                let (_, errorStr) = ErrorHelper.validateError(error: error)
                self.errorMessage.value = errorStr
            }
            
            self.isUsersSearched = true
            completion(true)
        })
    }
    
    private func searchEditions(keyWord: String, completion: @escaping (Bool) -> Void) {
        searchUseCase.searchEditions(keyWord: keyWord, completion: { result in
            switch result {
            case .success(let items):
                self.editionsItems += items

            case .failure(let error):
                let (_, errorStr) = ErrorHelper.validateError(error: error)
                self.errorMessage.value = errorStr
            }
            
            self.isEditionsSearched = true
            completion(true)
        })
    }
    
    private func searchNfts(keyWord: String, completion: @escaping (Bool) -> Void) {
        searchUseCase.searchNfts(keyWord: keyWord, completion: { result in
            switch result {
            case .success(let items):
                self.nftsItems += items

            case .failure(let error):
                let (_, errorStr) = ErrorHelper.validateError(error: error)
                self.errorMessage.value = errorStr
            }
            
            self.isNftsSearched = true
            completion(true)
        })
    }
    
    func didSelectItem(at index: Int, completion: @escaping (SearchCellViewModel) -> Void) {
        let viewModel = items.value[index]
        
        completion(viewModel)
    }
    
    private func serachDone() {
        if self.isSearched() {
            if usersItems.count > 0 {
                items.value += [SearchCellViewModel(id: -1, title: NSLocalizedString("Users", comment: ""), subtitle: nil, mediaUrl: nil, type: .separator)]
                items.value += usersItems
            }
            
            if editionsItems.count > 0 {
                items.value += [SearchCellViewModel(id: -2, title: "Drop Shop", subtitle: nil, mediaUrl: nil, type: .separator)]
                items.value += editionsItems
            }
            
            if nftsItems.count > 0 {
                items.value += [SearchCellViewModel(id: -3, title: "NFTs", subtitle: nil, mediaUrl: nil, type: .separator)]
                items.value += nftsItems
            }
            
            items.value = items.value.uniqued()
        }
    }
    
    private func resetSearch() {
        items.value = []
        
        usersItems = []
        editionsItems = []
        nftsItems = []
        
        isUsersSearched = false
        isEditionsSearched = false
        isNftsSearched = false
    }
    
    private func isSearched() -> Bool {
        return isNftsSearched && isEditionsSearched && isNftsSearched
    }
    
    private func isSearching() -> Bool {
        return isNftsSearched || isEditionsSearched || isNftsSearched
    }
    
}
