//
//  TestUtilities.swift
//  TMDBTests
//
//  Created by devadmin on 19/12/2022.
//

import Foundation
import XCTest
import SwiftyJSON
@testable import TMDB

struct TestUtilities {
    static func getMockResponse(with inBundle: XCTestCase, for fileName: String) -> JSON? {
        let bundle = Bundle(for: type(of: inBundle))
        if let path = bundle.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                    let response = JSON(jsonResult)
                    return response
                }
            } catch {
                // handle error
            }
        }
        return nil
    }
}

enum MOCK_JSON_FILENAME: String {
    case getMovies
    case getFailureMovies
}
