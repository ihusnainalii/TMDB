//
//  NetworkManager.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import Foundation
import Alamofire
import SwiftyJSON
import MobileCoreServices

// Network ErrorMessage
let GENERIC_ERROR_MESSAGE = "Please check your internet connection and try again the same request or hold a moment while we try to reconnect."

class NetworkManager: NSObject {
    
    // MARK: - Shared instance
    static let shared = NetworkManager()
    private let alamofireManager = AlamofireManager()
    
    // MARK: - Shared Variables
    let retryLimit = 3
    
    // MARK: - Constants
    
    // MARK: - Shared methods
    private func addHeaders(_ isJson: Bool = false) -> HTTPHeaders {
        var header: HTTPHeaders = [:]
        if isJson {
            header[Utilities.Headers.contentType] = Utilities.Headers.JsonEncoded
        } else {
            header[Utilities.Headers.contentType] = Utilities.Headers.FormUrlEncoded
        }
        return header
    }
    
    // MARK: - Request for General Apis
    func request(with url: String, endPoint: EndPointEnum, parameters: Params = [:], completion: @escaping CompletionNetwork) {
        
        // Alamofire request
        self.alamofireManager.session.request(url, method: endPoint.httpMethod,
                                              parameters: parameters,
                                              encoding: endPoint.isJSONEncoded ? JSONEncoding.default : URLEncoding.default,
                                              headers: self.addHeaders(endPoint.isJSONEncoded))
        .validate(statusCode: 200..<600)
        .responseJSON { response in
            
            switch response.result {
            case .failure(let error):
                
                // Failure completion block
                completion(.failure(.network(string: GENERIC_ERROR_MESSAGE + error.localizedDescription)))

            case .success(let data):
                
                // Success block
                let json = JSON(data)
                if let statusCode = response.response?.statusCode, statusCode == 200 {
                    completion(.success(json))
                } else {
                    completion(.failure(.custom(string: "Data not found")))
                }
            }
        }
    }
    
    func discardPreviousReequests() {
        self.alamofireManager.session.session.getTasksWithCompletionHandler { dataTasks, _, _ in
            dataTasks.forEach { $0.cancel() }
        }
    }
}

extension Dictionary {
    var toJson: Data? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted]) else {
            return nil
        }
        return theJSONData
    }
}
