//
//  MoviesRepository.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import Foundation

protocol MoviesDependency {
    func fetchMovies(completion: @escaping GenericCompletion<Any>)
}

class MoviesRepository: MoviesDependency {
    
    private var monitorNetwork: MonitorNetwork
    
    init() {
        monitorNetwork = MonitorNetwork()
    }
    
    /// GET function for generic api calls
    /// - Parameter completion: A comletion handler for success,
    func fetchMovies(completion: @escaping GenericCompletion<Any>) {
        
        // enum
        let endPoint: EndPointEnum = .fetchMovies
        
        // check if internet is connected
        monitorNetwork.Connection(observe: false) { connection in
            if let isConnected = connection, isConnected {
                
                // check url if valid
                guard var url = endPoint.url else {
                    return completion(.failure(.custom(string: "URL is not valid")))
                }
                
                // Network request
                NetworkManager.shared.request(with: &url, endPoint: endPoint) { result in
                    
                        switch result {
                        case .success(let metaData) :
                            if let rawData  = try? metaData.rawData() {
                                do {
                                    let response = try JSONDecoder().decode(TMDBResponse.self, from: rawData)
                                    completion(.success(response))
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
                // if internet is not available
                completion(.failure(.network(string: GENERIC_ERROR_MESSAGE)))
            }
        }
    }
}
