//
//  RealmMemoryType.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import Foundation

// This enum is used to specify a type of memory to store some data or do migration.
public enum RealmMemoryType {
    // is a General Storage.
    case inStorage

    // is a Testing Storage or Short time storage.
    case inMemory(identifier: String?)

    var associated: String? {
        switch self {
        case .inStorage:
            return nil
        case .inMemory(let identifier):
            return identifier
        }
    }
}
