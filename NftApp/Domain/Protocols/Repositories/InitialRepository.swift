//
//  InitialRepository.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

protocol InitialRepository {
    
    func getInitialData(completion: @escaping (Result<InitialResponseDTO, Error>) -> Void)
    
}
