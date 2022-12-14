//
//  MoviesViewModel.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import Foundation
import RxSwift
import RxCocoa

class MoviesViewModel: BaseViewModel {
    
    // MARK: - Variables
    var repository: MoviesDependency?
    let movies = BehaviorRelay<[MovieCellViewModel]>(value: [])
    
    // MARK: - Initialiser
    init(_ repository: MoviesRepository) {
        self.repository = repository
    }
    
    func fetchMovies() {
        
        // Add Loader
        self.isLoading.accept(true)
        
        // Request
        repository?.fetchMovies { result in
            // Remove Loader
            self.isLoading.accept(false)
            
            // Response handling
            switch result {
            case .success(let metaData):
                if let metaDataResponse = metaData as? TMDBResponse {
                    var movies = metaDataResponse.results ?? []
                    self.movies.accept(self.getCellViewModel(with: movies))
                }
                self.type.accept(.fetchMovies)
                self.isSuccess.accept(true)
            case .failure(let error):
                print("Parser error \(error)")
                self.setError(error.localizedDescription)
            }
        }
    }
    
    func  getCellViewModel(with movies: [Movie]) -> [MovieCellViewModel] {
        var movieCellVMList: [MovieCellViewModel] = []
        for movie in movies {
            movieCellVMList.append(MovieCellViewModel(movie))
        }
        return movieCellVMList
    }
}
