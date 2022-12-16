//
//  EndPointEnum.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import Foundation
import Alamofire

/// Intercerptor for  HTTP requests
enum EndPointEnum {
    
    // get movies list
    case fetchMovies
    case SearchMovies
}

/// defining end point types
extension EndPointEnum: EndPointType {
    
    var isAuthRequired: Bool {
        switch self {
        case .fetchMovies, .SearchMovies:
            return true
        }
    }
    
    var isJSONEncoded: Bool {
        switch self {
        case .fetchMovies, .SearchMovies:
            return false
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        // Post Method
        case .fetchMovies, .SearchMovies:
            return .get
        }
    }
    
    var url: String? {
        switch self {
        // User Repository
        case .fetchMovies:
            return APIURLs.fetchMovies
        case .SearchMovies:
            return APIURLs.searchMovies
        }
    }
}
