//
//  TMDBResponse.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import Foundation

struct TMDBResponse : Codable {
    
	let page : Int?
	let results : [Movie]?
	let totalPages : Int?
	let totalResults : Int?

	enum CodingKeys: String, CodingKey {

		case page = "page"
		case results = "results"
		case totalPages = "total_pages"
		case totalResults = "total_results"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		page = try values.decodeIfPresent(Int.self, forKey: .page)
		results = try values.decodeIfPresent([Movie].self, forKey: .results)
        totalPages = try values.decodeIfPresent(Int.self, forKey: .totalPages)
        totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults)
	}

}
