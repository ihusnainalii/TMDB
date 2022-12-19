//
//  TestMoviesRepository.swift
//  TMDBTests
//
//  Created by devadmin on 19/12/2022.
//

import Foundation
import XCTest
import RealmSwift
@testable import TMDB

class TestMoviesRepository: MoviesDependency {
    
    private var storage = InMemoryDB.shared
    private var bundle: XCTestCase
    private var path: MOCK_JSON_FILENAME
    
    init(bundle: XCTestCase, path: MOCK_JSON_FILENAME) {
        self.bundle = bundle
        self.path = path
    }
    
    /// GET function for getting movies
    /// - Parameter completion: A comletion handler for success,
    func fetchMovies(with page: Int?, completion: @escaping GenericCompletion<Any>) {
        let response = TestUtilities.getMockResponse(with: bundle, for: path.rawValue)
        if let rawData = try? response?.rawData() {
            do {
                let response = try JSONDecoder().decode(TMDBResponse.self, from: rawData)
                let pagination = response.getPagination()
                let movies = response.results
                completion(.success((movies, pagination)))
            } catch {
                completion(.failure(.parser(string: "Error While parsing")))
            }
        } else {
            completion(.failure(.custom(string: "Error No Data found")))
        }
    }
    
    func fetchFavoriteMovies(completion: @escaping GenericCompletion<Any>) {
        
    }
}
