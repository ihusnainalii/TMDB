//
//  MonitorNetwork.swift
//  NYTimee
//
//  Created by devadmin on 02/11/2022.
//

import Foundation
import Network

class MonitorNetwork {
    
    var monitor = NWPathMonitor()
    
    /// Checks if network is available
    /// - Parameters:
    ///   - observe: to check every time
    ///   - completionHandler: completionHandler for returning bool for success
    func Connection(observe: Bool, completionHandler: @escaping (_ isConnected: Bool?) -> Void) {
        monitor.pathUpdateHandler = { path in
            
            if path.status == .satisfied {
                completionHandler(_: true)
            } else {
                completionHandler(_: false)
            }
            
            if !observe {
                self.monitor.pathUpdateHandler = nil
            }
        }
       
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
}
