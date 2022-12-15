//
//  EndPontType.swift
//  TMDB
//
//  Created by devadmin on 14/12/2022.
//

import Foundation
import Alamofire

protocol EndPointType {
    var url: String? { get }
    var httpMethod: HTTPMethod { get }
    var isAuthRequired: Bool { get }
    var isJSONEncoded: Bool { get }
}
