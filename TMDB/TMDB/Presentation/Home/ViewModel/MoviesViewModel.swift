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
    let pagination = BehaviorRelay<Pagination>(value: Pagination())
    
    // MARK: - Initialiser
    init(_ repository: MoviesDependency) {
        self.repository = repository
    }
    
    func fetchMovies() {
        
        // Add Loader
        self.isLoading.accept(true)
        
        // Request
        repository?.fetchMovies(with: pagination.value.page) { result in
            // Remove Loader
            self.isLoading.accept(false)
            
            // Response handling
            switch result {
            case .success(let metaData):
                if let metaDataResponse = metaData as? (List<Movie>, Pagination) {
                    let vm = self.getCellViewModel(with: metaDataResponse.0)
                    self.movies.append(contentsOf: vm)
                    print("Pagination: \(metaDataResponse.1)")
                    self.pagination.accept(metaDataResponse.1)
                } else if let metaDataResponse = metaData as? List<Movie> {
                    let vm = self.getCellViewModel(with: metaDataResponse)
                    self.movies.append(contentsOf: vm)
                }
            case .failure(let error):
                print("Parser error \(error)")
                self.setError(error.localizedDescription)
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
