//
//  BaseViewModel.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel {
    
    // MARK: - Private Constants
    let bag = DisposeBag()
    
    // MARK: - Variables
    private let error = BehaviorRelay<Bool>(value: false)
    let errorMessage = BehaviorRelay<String?>(value: nil)
    let type = BehaviorRelay<EndPointEnum?>(value: nil)
    
    // MARK: - Model Function
    var hasError: Bool {
        return error.value
    }
    
    var message: Driver<String?> {
        return errorMessage.asDriver()
    }
    
    func setError(_ message: String) {
        self.error.accept(true)
        self.errorMessage.accept(message)
    }
    
    func setMessage(_ message: String) {
        self.error.accept(true)
        self.errorMessage.accept(message)
    }
    
    func getError() -> String {
        return errorMessage.value ?? ""
    }
    
    // RX
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var isSuccess: BehaviorRelay<Bool> = BehaviorRelay(value: false)
}
