//
//  Database.swift
//  TMDB
//
//  Created by devadmin on 15/12/2022.
//

import Foundation
import RealmSwift

class Database: DatabaseConfigurable {
    
    static let shared = Database()
    
    var realmMemoryType: RealmMemoryType {
        return .inStorage
    }
    
    var schemaName: String? {
        return "TMDBSchema"
    }
    
    var schemaVersion: UInt64? {
        0
    }
    
    var objectTypes: [Object.Type]? {
        return [Movie.self, Pagination.self, Suggestion.self]
    }
    
    var embeddedObjectTypes: [EmbeddedObject.Type]? {
        return nil
    }
    
    var migrationBlock: MigrationBlock? {
        let migrationBlock: MigrationBlock = { migration, oldSchemaVersion in
            
            // we can check schemaVersion also here to get neew and preecious items
            
            // oldSchemaVersion will handle previous db schema
            if oldSchemaVersion < 1 {
                
            }
            // migration will handle new changes
        }
        return migrationBlock
    }
}
