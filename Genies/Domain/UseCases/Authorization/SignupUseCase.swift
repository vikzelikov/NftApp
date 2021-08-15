//
//  SignupUseCase.swift
//  Genies
//
//  Created by Yegor on 15.08.2021.
//

import Foundation

protocol SignupUseCase {
    func signup(request: SignupRequestUseCase, completion: @escaping (Result<SignupResponseDTO, Error>) -> Void)
}

final class SignupUseCaseImpl: SignupUseCase {
    
    private let repository: AuthRepository?
    
    init() {
        self.repository = AuthRepositoryImpl()
    }
    
    func signup(request: SignupRequestUseCase, completion: @escaping (Result<SignupResponseDTO, Error>) -> Void) {

            repository?.signup(request: request, completion: { result in
//                switch result {
//                case .success(let page):
//                    print("")
//                case .failure(let error):
//                    print(" \(error)")
//                }
//                let responseMoviesDTO = try result.get()
//
//                //convertion from DTO
//                let movies = responseMoviesDTO.movies.map {
//                    Movie(id: String($0.id), title: $0.title, movieImageUrl: $0.movieImageUrl, overview: $0.overview, date: $0.releaseDate)
//                }
//                let moviesPage = MoviesPage(page: responseMoviesDTO.page, totalPages: responseMoviesDTO.totalPages, movies: movies)
//                completion(.success(moviesPage))
//
//                if case .success = result {
//                    //save query.query string in recent
//                }
        })
    }
}

struct SignupRequestUseCase {
    let login: String
    let email: String
    let password: String
    let sex: String
    let birthDate: String
}
