//
//  BaseViewModel.swift
//  Genies
//
//  Created by Yegor on 18.08.2021.
//

import Foundation

protocol BaseViewModel {
    
    var isLoading: Observable<Bool> { get }
    
    var isSuccess: Observable<Bool> { get }
    
    var errorMessage: Observable<String?> { get }
    
}
