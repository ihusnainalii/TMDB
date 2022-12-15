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
    init(_ repository: MoviesRepository, _ movies: [MovieCellViewModel]) {
        self.repository = repository
        self.movies.accept(movies)
    }
}
