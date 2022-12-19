//
//  TMDBMigration.swift
//  TMDBTests
//
//  Created by devadmin on 19/12/2022.
//

import XCTest
@testable import TMDB

final class TMDBMigration: XCTestCase {
    
    let db = InMemoryDB.shared

    // https://www.mongodb.com/docs/realm/sdk/swift/model-data/change-an-object-model/
    func testFirstVersion() throws {
        let expectation = self.expectation(description: "Realm manager API")
        let sample = MigrationSample()
        sample.firstName = "firstName 0"
        sample.lastName = "lastName 0"

        db.save(entity: sample, update: false) { result in
            switch result {
            case .success:
                XCTAssertTrue(true)
                expectation.fulfill()
            case .failure:
                XCTAssertTrue(false)
                expectation.fulfill()
            }
        }
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
}
