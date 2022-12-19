//
//  InMemoryDB.swift
//  TMDBTests
//
//  Created by devadmin on 19/12/2022.
//

import Foundation
import RealmSwift
@testable import TMDB

class InMemoryDB: DatabaseConfigurable {
    
    static let shared = InMemoryDB()
    
    var realmMemoryType: RealmMemoryType {
        return .inStorage
    }
    
    var schemaName: String? {
        return "TMDBUnitTestsSchema"
    }
    
    var schemaVersion: UInt64? {
        0
    }
    
    var objectTypes: [Object.Type]? {
        return [Movie.self, Pagination.self, Suggestion.self, MigrationSample.self]
    }
    
    var embeddedObjectTypes: [EmbeddedObject.Type]? {
        return nil
    }
    
    var migrationBlock: MigrationBlock? {
        let migrationBlock: MigrationBlock = { migration, oldSchemaVersion in
            
            if oldSchemaVersion < 1 {
                // Rename the "name" property to "yourName".
                // The renaming operation should be done outside of calls to `enumerateObjects(ofType: _:)`.
                migration.renameProperty(onType: MigrationSample.className(), from: "age", to: "yearsSinceBirth")
//                migration.renameProperty(onType: MigrationSample.className(), from: "name", to: "yourName")
            }

            // The enumerateObjects(ofType:_:) method iterates over
            // every Person object stored in the Realm file to apply the migration
            migration.enumerateObjects(ofType: MigrationSample.className()) { oldObject, newObject in
                // combine name fields into a single field
                let firstName = oldObject!["firstName"] as? String
                let lastName = oldObject!["lastName"] as? String
                newObject!["fullName"] = "\(firstName!) \(lastName!)"
            }
        }
        return migrationBlock
    }
}
