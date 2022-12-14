//
//  AlamofireManager.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import Foundation
import Alamofire

struct AlamofireManager {
    
    // MARK: - interceptors
    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
    
    // MARK: - logger
    let monitors = [AlamofireLogger()] as [EventMonitor]
    
    // MARK: - session
    var session = Session()
    
    init() {
        session = Session(
            interceptor: interceptors,
            eventMonitors: monitors
        )
    }
}
