//
//  TestMovieFetch.swift
//  TMDBTests
//
//  Created by devadmin on 19/12/2022.
//

import Foundation
import XCTest
import RealmSwift
@testable import TMDB

final class TestMovieFetch: XCTestCase {
    
    func testSuccessFetch() {
        let repo = TestMoviesRepository(bundle: self, path: .getMovies)
        let expectation = self.expectation(description: "Mokee Data API")
        repo.fetchMovies(with: 1) { result in
            // Response handling
            switch result {
            case .success(let metaData):
                if metaData is (List<Movie>, Pagination) {
                    XCTAssertTrue(true)
                    expectation.fulfill()
                } else {
                    XCTAssertTrue(false)
                    expectation.fulfill()
                }
            case .failure:
                XCTAssertTrue(false)
                expectation.fulfill()
            }
        }
        
        self.waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testFailureFetch() {
        let repo = TestMoviesRepository(bundle: self, path: .getFailureMovies)
        let expectation = self.expectation(description: "Mokee Data API")
        repo.fetchMovies(with: 1) { result in
            // Response handling
            switch result {
            case .success(let metaData):
                if metaData is (List<Movie>, Pagination) {
                    XCTAssertTrue(false)
                    expectation.fulfill()
                } else {
                    XCTAssertTrue(true)
                    expectation.fulfill()
                }
            case .failure:
                XCTAssertTrue(true)
                expectation.fulfill()
            }
        }
        
        self.waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testAddMovie() {
        
        let movie = Movie()
        let randomIntForKey = Int.random(in: 1..<500000000)
        movie.id = randomIntForKey
        movie.primaryId = randomIntForKey
        movie.title = randomString(of: 15)
        movie.isFavorite = true
        
        InMemoryDB.shared.save(entity: movie, update: true) { realmResponse in
            switch realmResponse {
            case .success:
                XCTAssertTrue(true)
            case .failure:
                XCTAssertTrue(false)
            }
        }
    }
    
    func testQueryObjects() {
        let movies = InMemoryDB.shared.queryAll(returningClass: Movie.self)
        XCTAssertTrue(movies != nil && !(movies!.isEmpty))
    }
    
    
    func testFetchFavorites() {
        let movies = InMemoryDB.shared.queryAll(returningClass: Movie.self)
        if let favorites = movies?.list.filter({ movie in
            movie.isFavorite ?? false
        }) {
            XCTAssertTrue(!favorites.isEmpty)
        } else {
            XCTAssertFalse(true)
        }
    }
    
    func testMarkUnfavorite() {
        let movies = InMemoryDB.shared.queryAll(returningClass: Movie.self)
        if let favorites = movies?.list.filter({ movie in
            movie.isFavorite ?? false
        }) {
            if let first = favorites.first {
                guard let realm = InMemoryDB.shared.realm() else {
                    XCTAssertFalse(true)
                    return
                }
                do  {
                    try realm.write {
                        first.isFavorite = false
                    }
                    XCTAssertTrue(true)
                } catch {
                    XCTAssertFalse(true)
                }
            } else {
                XCTAssertFalse(true)
            }
        } else {
            XCTAssertFalse(true)
        }
    }
    
    
    func randomString(of length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }

}
