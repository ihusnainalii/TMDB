//
//  MovieCellViewModel.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import Foundation
import RxSwift
import RxCocoa

class MovieCellViewModel: BaseViewModel {
    
    // MARK: - Variables
    let movie = BehaviorRelay<Movie?>(value: nil)
    
    // MARK: - Initialiser
    init(_ movie: Movie) {
        self.movie.accept(movie)
    }
}
