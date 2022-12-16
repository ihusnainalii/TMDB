//
//  Suggestion.swift
//  TMDB
//
//  Created by devadmin on 16/12/2022.
//

import Foundation
import RealmSwift

class Suggestion: Object {
    @Persisted var keyword : String?
    @Persisted(primaryKey: true) var primaryId = 0
    
    override init() {}
    
    init(_ keyword: String, _ id: Int) {
        self.keyword = keyword
        self.primaryId = id
    }
}
