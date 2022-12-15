//
//  Movie.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import Foundation
import RealmSwift

class Movie: Object, Codable {
    
    @Persisted var adult : Bool?
    @Persisted var backdropPath : String?
    @Persisted var id: Int?
    @Persisted(primaryKey: true) var primaryId = 0
    @Persisted var originalLanguage : String?
    @Persisted var originalTitle : String?
    @Persisted var overview : String?
    @Persisted var popularity : Double?
    @Persisted var posterPath : String?
    @Persisted var releaseDate : String?
    @Persisted var title : String?
    @Persisted var video : Bool?
    @Persisted var voteAverage : Double?
    @Persisted var voteCount : Int?
    @Persisted var isFavorite: Bool?
    
    
    override init() {}
    
    enum CodingKeys: String, CodingKey {
        
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case id = "id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview = "overview"
        case popularity = "popularity"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title = "title"
        case video = "video"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        adult = try values.decodeIfPresent(Bool.self, forKey: .adult)
        backdropPath = try values.decodeIfPresent(String.self, forKey: .backdropPath)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        originalLanguage = try values.decodeIfPresent(String.self, forKey: .originalLanguage)
        originalTitle = try values.decodeIfPresent(String.self, forKey: .originalTitle)
        overview = try values.decodeIfPresent(String.self, forKey: .overview)
        popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
        posterPath = try values.decodeIfPresent(String.self, forKey: .posterPath)
        releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        video = try values.decodeIfPresent(Bool.self, forKey: .video)
        voteAverage = try values.decodeIfPresent(Double.self, forKey: .voteAverage)
        voteCount = try values.decodeIfPresent(Int.self, forKey: .voteCount)
        isFavorite = false
    }
    
    
    func getReleaseDate() -> String? {
        if let date = self.releaseDate {
            return "Release Date\n\(date)"
        } else {
            return nil
        }
    }
}
