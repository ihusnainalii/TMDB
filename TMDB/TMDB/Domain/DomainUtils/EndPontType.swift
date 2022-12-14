//
//  EndPontType.swift
//  NYTimee
//
//  Created by devadmin on 02/11/2022.
//

import Foundation
import Alamofire

protocol EndPointType {
    var url: String? { get }
    var httpMethod: HTTPMethod { get }
    var isAuthRequired: Bool { get }
    var isJSONEncoded: Bool { get }
}
