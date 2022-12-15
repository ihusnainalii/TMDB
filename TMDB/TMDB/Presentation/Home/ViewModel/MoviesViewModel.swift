//
//  MoviesViewModel.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class MoviesViewModel: BaseViewModel {
    
    // MARK: - Variables
    var repository: MoviesDependency?
    let movies = BehaviorRelay<[MovieCellViewModel]>(value: [])
    let favorites = BehaviorRelay<[MovieCellViewModel]>(value: [])
    
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
                if let metaDataResponse = metaData as? List<Movie> {
                    self.movies.accept(self.getCellViewModel(with: metaDataResponse))
                }
            case .failure(let error):
                print("Parser error \(error)")
                self.setError(error.localizedDescription)
            }
        }
    }
    
    func fetchFavorites() {
        
        // Add Loader
        self.isLoading.accept(true)

        // Request
        repository?.fetchFavoriteMovies { result in

            // Remove Loader
            self.isLoading.accept(false)

            // Response handling
            switch result {
            case .success(let metaData):
                if let metaDataResponse = metaData as? List<Movie> {
                    self.favorites.accept(self.getCellViewModel(with: metaDataResponse))
                }
                self.isSuccess.accept(true)
            case .failure(let error):
                print("Parser error \(error)")
            }
        }
    }
    
    func  getCellViewModel(with movies: List<Movie>) -> [MovieCellViewModel] {
        var movieCellVMList: [MovieCellViewModel] = []
        for movie in movies {
            movieCellVMList.append(MovieCellViewModel(movie))
        }
        return movieCellVMList
    }
}
