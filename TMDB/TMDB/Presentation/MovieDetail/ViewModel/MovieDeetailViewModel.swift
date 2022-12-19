//
//  MovieDetailViewModel.swift
//  TMDB
//
//  Created by devadmin on 16/12/2022.
//

import UIKit
import RxSwift
import RxCocoa

class MovieDetailViewModel: BaseViewModel {
    
    // MARK: - Variables
    let movie = BehaviorRelay<Movie?>(value: nil)
    
    // MARK: - Initialiser
    init(_ movie: Movie) {
        self.movie.accept(movie)
    }
    
    func updateFavorite() {
        
        // Make favorite
        if let movie = movie.value {
            guard let realm = Database.shared.realm() else { return }
            try? realm.write {
                if let isFav = movie.isFavorite {
                    movie.isFavorite = !isFav
                }
            }
            self.movie.accept(movie)
        }
        
        self.isSuccess.accept(true)
    }
}
