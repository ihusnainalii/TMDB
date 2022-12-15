//
//  Utilities.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import Foundation
import UIKit

struct Utilities {
    
    // MARK: - Color
    struct Colors {
        static let AppColor = UIColor(named: "AppColor")
    }
    
    // MARK: - Images
    struct Assets {
        static let Placeholderimg = UIImage(systemName: "placeholder")
        static let Favorite = UIImage(systemName: "heart.fill")
        static let Unfavorite = UIImage(systemName: "heart")
    }
    
    // MARK: - Headers
    struct Headers {
        static let contentType = "Content-Type"
        static let FormUrlEncoded = "application/x-www-form-urlencoded"
        static let JsonEncoded = "application/json"
    }
}
