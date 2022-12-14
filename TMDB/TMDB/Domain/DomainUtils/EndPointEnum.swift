//
//  EndPointEnum.swift
//  NYTimee
//
//  Created by devadmin on 02/11/2022.
//

import Foundation
import Alamofire

/// Intercerptor for  HTTP requests
enum EndPointEnum {
    
    // get movies list
    case fetchMovies
}

/// defining end point types
extension EndPointEnum: EndPointType {
    
    var isAuthRequired: Bool {
        switch self {
        case .fetchMovies:
            return true
        }
    }
    
    var isJSONEncoded: Bool {
        switch self {
        case .fetchMovies:
            return false
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        // Post Method
        case .fetchMovies:
            return .get
        }
    }
    
    var url: String? {
        switch self {
        // User Repository
        case .fetchMovies:
            return APIURLs.fetchMovies
        }
    }
}
