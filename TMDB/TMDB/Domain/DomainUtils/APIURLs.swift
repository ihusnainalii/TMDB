//
//  APIURLs.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import Foundation

/// This struct is used to set url endpoints
struct EndPoints {
    
    // MARK: - Public variables
    var requestedURL: String?
    
    // MARK: - init
    init(with URI: String) {
        let configurators = AppConfiguration()
        requestedURL = configurators.baseURL + URI
    }
}

struct APIURLs {
    // Fetch Movies
    static let fetchMovies = EndPoints(with: "movie/popular").requestedURL
    static let searchMovies = EndPoints(with: "search/movie").requestedURL
}


