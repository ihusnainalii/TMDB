//
//  AppConfiguration.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import Foundation

/// Configuration for base url and image url
final class AppConfiguration {
    
    lazy var baseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
    
    lazy var apiKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "ApiKey") as? String else {
            fatalError("ApiKey must not be empty in plist")
        }
        return "?api_key=\(key)"
    }()
    
    lazy var imageBasePath: String = {
        guard let imageBasePath = Bundle.main.object(forInfoDictionaryKey: "ImageBasePath") as? String else {
            fatalError("ImageBasePath must not be empty in plist")
        }
        return imageBasePath
    }()
}
