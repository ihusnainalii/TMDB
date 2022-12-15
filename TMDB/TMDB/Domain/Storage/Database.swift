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
        return [Movie.self]
    }

    var embeddedObjectTypes: [EmbeddedObject.Type]? {
        return nil
    }
    
    var migrationBlock: MigrationBlock? {
        return nil
    }
    
}
