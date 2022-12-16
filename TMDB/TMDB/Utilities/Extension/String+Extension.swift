//
//  String+Eextension.swift
//  TMDB
//
//  Created by devadmin on 16/12/2022.
//

import Foundation

extension String {
    func getPath(with page: Int? = nil, _ keyword: String? = nil) -> (Bool, String) {
        
        // check url if valid
        guard let url = URL(string: self) else {
            return (false, "")
        }
        
        // Query items
        var queryItems: [URLQueryItem] = []
        
        // Append api key in needed
        queryItems.append(URLQueryItem(name: "api_key", value: AppConfiguration().apiKey))
        
        // Page number
        if let pageData = page {
            queryItems.append(URLQueryItem(name: "page", value: "\(pageData)"))
        }
        
        if let keywordData = keyword {
            queryItems.append(URLQueryItem(name: "query", value: "\(keywordData)"))
        }
        
        // Updated URL with query Items
        guard let queryItemsUrl = url.append(queryItems) else {
            return (false, "")
        }
        
        // Print URL
        print("URL with query items: \(queryItemsUrl.absoluteString)")
        
        return (true, queryItemsUrl.absoluteString)
    }
}
