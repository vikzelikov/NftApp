//
//  SearchViewModel.swift
//  NftApp
//
//  Created by Yegor on 05.11.2021.
//

import Foundation

protocol SearchViewModel: BaseViewModel {
    
    var items: Observable<[[SearchCellViewModel]]> { get }
    var headers: [String] { get set }
    func searchDidTap(keyWord: String)
    
    func didSelectItem(section: Int, at index: Int, completion: @escaping (SearchCellViewModel) -> Void)
    
}

enum TypeSearch {
    case users
    case editions
    case nfts
}

class SearchViewModelImpl: SearchViewModel {
    
    private let searchUseCase: SearchUseCase
    
    var items: Observable<[[SearchCellViewModel]]> = Observable([])
    var headers: [String] = ["Users", "Drop Shop", "NFTs"]
    
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

            case .failure: break
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

            case .failure: break
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

            case .failure: break
            }
            
            self.isNftsSearched = true
            completion(true)
        })
    }
    
    func didSelectItem(section: Int, at index: Int, completion: @escaping (SearchCellViewModel) -> Void) {
        if items.value[section].indices.contains(index) {
            let viewModel = items.value[section][index]
            
            completion(viewModel)
        }
    }
    
    private func serachDone() {
        if self.isSearched() {
            items.value.append(usersItems)
            items.value.append(editionsItems)
            
//            if nftsItems.count > 0 {
//                items.value.append(nftsItems)
//            }
            
            items.value = items.value.uniqued()
        }
    }
    
    private func resetSearch() {
        items.value.removeAll()
        
        usersItems.removeAll()
        editionsItems.removeAll()
        nftsItems.removeAll()
        
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
