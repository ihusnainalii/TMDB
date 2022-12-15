//
//  Typealiase.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import Foundation
import SwiftyJSON

// MARK: - TypeAlias for data type
typealias Params = [String: Any]

// MARK: - Completion Block
typealias CompletionNetwork = ((Result<JSON, ErrorResult>) -> Void)

// MARK: - Completion for Repositories
typealias GenericCompletion<Model> = ((Result<Model?, ErrorResult>) -> Void)

enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}

enum ErrorResult: Error {
    case network(string: String)
    case parser(string: String)
    case db(string: String)
    case custom(string: String)
}
