//
//  FavoriteMoviesViewModel.swift
//  TMDB
//
//  Created by devadmin on 15/12/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class FavoriteMoviesViewModel: BaseViewModel {
    
    // MARK: - Variables
    var repository: MoviesDependency?
    let movies = BehaviorRelay<[MovieCellViewModel]>(value: [])
    
    // MARK: - Initialiser
    init(_ repository: MoviesRepository) {
        self.repository = repository
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
                    self.movies.accept(self.getCellViewModel(with: metaDataResponse))
                }
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
