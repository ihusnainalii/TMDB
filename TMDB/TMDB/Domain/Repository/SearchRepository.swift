//
//  SearchRepository.swift
//  TMDB
//
//  Created by devadmin on 16/12/2022.
//

import Foundation
import RealmSwift

protocol SearchDependency {
    func search(with page: Int?, _ query: String?, completion: @escaping GenericCompletion<Any>)
}

class SearchRepository: SearchDependency {
    
    private var monitorNetwork: MonitorNetwork
    private var storage = Database.shared
    
    init() {
        monitorNetwork = MonitorNetwork()
    }
    
    /// GET function for searching movies
    /// - Parameter completion: A comletion handler for success,
    func search(with page: Int?, _ query: String?, completion: @escaping GenericCompletion<Any>) {
        
        // enum
        let endPoint: EndPointEnum = .SearchMovies
        
        // check if internet is connected
        monitorNetwork.Connection(observe: false) { connection in
            if let isConnected = connection, isConnected {
                
                // check url if valid
                guard let urlString = endPoint.url else {
                    return completion(.failure(.custom(string: "URL is not valid")))
                }
                
                // get complete URL with query items
                let urlPath = urlString.getPath(with: page, query)
                if !urlPath.0 {
                    return completion(.failure(.custom(string: "URL is not valid")))
                }
                
                // Network request
                NetworkManager.shared.request(with: urlPath.1, endPoint: endPoint) { result in
                    switch result {
                    case .success(let metaData) :
                        if let rawData  = try? metaData.rawData() {
                            do {
                                let response = try JSONDecoder().decode(TMDBResponse.self, from: rawData)
                                let pagination = response.getPagination()
                                let movies = response.results
                                completion(.success((movies, pagination)))
                            } catch {
                                completion(.failure(.parser(string: "Error While parsing")))
                            }
                        } else {
                            completion(.failure(.custom(string: "Error No Data found")))
                        }
                    case .failure(let error) :
                        completion(.failure(error))
                    }
                }
            } else {
                // self.fetchCachedMovies(completion: completion)
            }
        }
    }
    
    func saveSuggestion(_ query: String?) {
        guard let queryString = query else {return}
        let stamp = Int(Date().timeIntervalSince1970)
        let primaryId = stamp
        let suggestion = Suggestion(queryString, primaryId)
        DispatchQueue.main.async {
            // Save suggestion object
            self.storage.save(entity: suggestion, update: true) { realmResponse in
                switch realmResponse {
                case .success:
                    print("suggestion saved")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getPreviousSeggestions(completion: @escaping GenericCompletion<Any>) {
        if let result = self.storage.queryAll(returningClass: Suggestion.self) {
            let last10Reecords = result.lazy.prefix(10).base
            completion(.success(last10Reecords.list))
        } else {
            completion(.failure(.db(string: "No data found")))
        }
    }
}

