//
//  BaseInterceptor.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import Foundation
import Alamofire
import SwiftyJSON

class BaseInterceptor: RequestInterceptor {
    
    let retryLimit = 3
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard request.retryCount < retryLimit else {
            completion(.doNotRetry)
            return
        }
        print("\nretried; retry count: \(request.retryCount)\n")
        
        if request.retryCount < retryLimit {
            guard let statusCode = request.response?.statusCode else {
                completion(.doNotRetry)
                return
            }
            switch statusCode {
            case 401:
                completion(.retry)
            default:
                completion(.doNotRetry)
            }
        }
    }
}
