//
//  DatabaseConfigurable+LegacyMigration.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import RealmSwift

// MARK: Legacy Migration
extension DatabaseConfigurable {
    var legacyMigration: MigrationBlock {
        return { (migration, oldSchemaVersion) in

        }
    }
}
