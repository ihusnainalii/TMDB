//
//  TMDBResponse.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import Foundation
import RealmSwift

class TMDBResponse: Object, Codable {
    
	@Persisted var page : Int?
	@Persisted var results: List<Movie>
	@Persisted var totalPages : Int?
	@Persisted var totalResults : Int?

	enum CodingKeys: String, CodingKey {

		case page = "page"
		case results = "results"
		case totalPages = "total_pages"
		case totalResults = "total_results"
	}
    
    override init() {}

    required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		page = try values.decodeIfPresent(Int.self, forKey: .page)
        results = try values.decodeIfPresent(List<Movie>.self, forKey: .results) ?? List<Movie>()
        totalPages = try values.decodeIfPresent(Int.self, forKey: .totalPages)
        totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults)
	}

}
