//
//  SearchViewModel.swift
//  TMDB
//
//  Created by devadmin on 16/12/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class SearchViewModel: BaseViewModel {
    
    // MARK: - Variables
    var repository: SearchRepository?
    let movies = BehaviorRelay<[MovieCellViewModel]>(value: [])
    let suggestion = BehaviorRelay<[SearchListViewModel]>(value: [])
    let pagination = BehaviorRelay<Pagination>(value: Pagination())
    let query = BehaviorRelay<String?>(value: nil)
    
    // MARK: - Initialiser
    init(_ repository: SearchRepository) {
        self.repository = repository
    }
    
    func searchMovies() {
        // Request
        repository?.search(with: pagination.value.page, query.value) { result in
            // Response handling
            switch result {
            case .success(let metaData):
                if let metaDataResponse = metaData as? (List<Movie>, Pagination) {
                    let vm = self.getCellViewModel(with: metaDataResponse.0)
                    self.movies.append(contentsOf: vm)
                    self.pagination.accept(metaDataResponse.1)
                }
            case .failure(let error):
                print("Parser error \(error)")
                self.setError(error.localizedDescription)
            }
        }
    }
    
    func saveSuggestion() {
        repository?.saveSuggestion(query.value)
    }
    
    func getSuggestions() {
        repository?.getPreviousSeggestions { result in
            // Response handling
            switch result {
            case .success(let metaData):
                if let suggestions = metaData as? List<Suggestion> {
                    let vm = self.getSuggestionCell(with: suggestions)
                    self.suggestion.accept(vm)
                }
            case .failure(let error):
                print("Parser error \(error)")
                self.setError(error.localizedDescription)
            }
        }
    }
    
    private func getCellViewModel(with movies: List<Movie>) -> [MovieCellViewModel] {
        var movieCellVMList: [MovieCellViewModel] = []
        for movie in movies {
            movieCellVMList.append(MovieCellViewModel(movie))
        }
        return movieCellVMList
    }
    
    private func getSuggestionCell(with suggestions: List<Suggestion>) -> [SearchListViewModel] {
        var searchListViewModel: [SearchListViewModel] = []
        for suggestion in suggestions {
            searchListViewModel.append(SearchListViewModel(suggestion))
        }
        return searchListViewModel.reversed()
    }
}
