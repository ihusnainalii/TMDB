//
//  SearchListViewModel.swift
//  TMDB
//
//  Created by devadmin on 16/12/2022.
//

import Foundation
import RxSwift
import RxCocoa

class SearchListViewModel: BaseViewModel {
    
    // MARK: - Variables
    let suggestion = BehaviorRelay<Suggestion?>(value: nil)
    
    // MARK: - Initialiser
    init(_ suggestion: Suggestion) {
        self.suggestion.accept(suggestion)
    }
}
