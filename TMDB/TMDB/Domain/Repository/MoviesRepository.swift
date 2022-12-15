//
//  MoviesRepository.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import Foundation
import RealmSwift

protocol MoviesDependency {
    func fetchMovies(completion: @escaping GenericCompletion<Any>)
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
                                    let movies = response.results
                                    self.saveMovies(movies, completion: completion)
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
    
    private func saveMovies(_ movies: List<Movie>, completion: @escaping GenericCompletion<Any>) {
        
        var moviesObjects = [Movie]()
        for movie in movies {
            let movieData = movie
            if let id = movieData.id {
                movieData.primaryId = id
            }
            moviesObjects.append(movieData)
        }
        
        DispatchQueue.main.async {
            self.storage.save(entities: moviesObjects, update: true) { realmResponse in
                switch realmResponse {
                case .success:
                    print("Data saved")
                    completion(.success(movies))
                case .failure(let error):
                    completion(.failure(.db(string: error.localizedDescription)))
                }
            }
        }
    }
    
    private func fetchCachedMovies(completion: @escaping GenericCompletion<Any>) {
        DispatchQueue.main.async {
            let result = self.storage.queryAll(returningClass: Movie.self)
            print("local data get")
            completion(.success(result?.list))
        }
    }
    
    func fetchFavoriteMovies(completion: @escaping GenericCompletion<Any>) {
        DispatchQueue.main.async {
            let result = self.storage.queryAll(returningClass: Movie.self)
            if let favorites = result?.list.filter({ movie in
                movie.isFavorite ?? false
            }) {
                print("favorite movies data get with count \(favorites.count )")
                var movies = List<Movie>()
                for movie in favorites {
                    movies.append(movie)
                }
                completion(.success(movies))
            }
        }
    }
}
