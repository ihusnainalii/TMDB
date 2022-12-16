//
//  MoviesRepository.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import Foundation
import RealmSwift

protocol MoviesDependency {
    func fetchMovies(with page: Int?, completion: @escaping GenericCompletion<Any>)
    func fetchFavoriteMovies(completion: @escaping GenericCompletion<Any>)
}

class MoviesRepository: MoviesDependency {
    
    private var monitorNetwork: MonitorNetwork
    private var storage = Database.shared
    
    init() {
        monitorNetwork = MonitorNetwork()
    }
    
    /// GET function for getting movies
    /// - Parameter completion: A comletion handler for success,
    func fetchMovies(with page: Int?, completion: @escaping GenericCompletion<Any>) {
        
        // enum
        let endPoint: EndPointEnum = .fetchMovies
        
        // check if internet is connected
        monitorNetwork.Connection(observe: false) { connection in
            if let isConnected = connection, isConnected {
                
                // check url if valid
                guard let urlString = endPoint.url else {
                    return completion(.failure(.custom(string: "URL is not valid")))
                }
                
                // get complete URL with query items
                let urlPath = urlString.getPath(with: page)
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
                                self.saveMovies(movies, pagination, completion: completion)
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
                self.fetchCachedMovies(completion: completion)
            }
        }
    }
    
    private func saveMovies(_ movies: List<Movie>, _ pagination: Pagination, completion: @escaping GenericCompletion<Any>) {
        
        var moviesObjects = [Movie]()
        for movie in movies {
            let movieData = movie
            if let id = movieData.id {
                movieData.primaryId = id
            }
            moviesObjects.append(movieData)
        }
        
        DispatchQueue.main.async {
            
            // Save pagination object
            self.storage.save(entity: pagination, update: true) { realmResponse in
                switch realmResponse {
                case .success:
                    print("Pagination saved")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            // Save movies object
            self.storage.save(entities: moviesObjects, update: true) { realmResponse in
                switch realmResponse {
                case .success:
                    let result = self.storage.queryAll(returningClass: Movie.self)
                    completion(.success((result?.list, pagination)))
                case .failure(let error):
                    completion(.failure(.db(string: error.localizedDescription)))
                }
            }
        }
    }
    
    private func fetchCachedMovies(completion: @escaping GenericCompletion<Any>) {
        DispatchQueue.main.async {
            let result = self.storage.queryAll(returningClass: Movie.self)
            if let resultPagination = self.storage.queryAll(returningClass: Pagination.self)?.first {
                completion(.success((result?.list, resultPagination)))
            } else {
                completion(.success(result?.list))
            }
        }
    }
    
    func fetchFavoriteMovies(completion: @escaping GenericCompletion<Any>) {
        DispatchQueue.main.async {
            let result = self.storage.queryAll(returningClass: Movie.self)
            if let favorites = result?.list.filter({ movie in
                movie.isFavorite ?? false
            }) {
                print("favorite movies data get with count \(favorites.count )")
                let movies = List<Movie>()
                for movie in favorites {
                    movies.append(movie)
                }
                completion(.success(movies))
            }
        }
    }
}
