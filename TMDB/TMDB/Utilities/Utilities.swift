//
//  Utilities.swift
//  NYTimee
//
//  Created by devadmin on 02/11/2022.
//

import Foundation
import UIKit

struct Utilities {
    
    // MARK: - Color
    struct Colors {
        static let AppColor = UIColor(named: "AppColor")
        static let DisableTextColor = UIColor(named: "DisableColor")
    }
    
    // MARK: - Images
    struct Assets {
        static let appLogo = "AppLogo"
        static let placeholderimg = "placeholderimg"
        static let kscPayBtnbg = UIImage(named: "kscPayBtnbg")
        static let PLACE_HOLDER = UIImage(named: "placeHolder")
    }
    
    // MARK: - Constant
    struct Constants {
        
        // General App Constants
        static let appName = "Limou Cloud"
        static let kNewsTitleString = "NY Times Most Popular"
        
        // General Strings
        static let pageSize = 10
        static let blankValue = ""
        static let intOValue = 0
        static let stringToDoubleFormate = "%f"
        static let double0Value = 0.0
        static let float0Value: Float = 0.0
        static let falseValue = false
        static let trueValue = true
        
        // General String
        static let WaringStr = ""
        static let InfoStr = "Info!"
        static let ErrorStr = ""
    }
    
    // MARK: - Headers
    struct Headers {
        static let contentType = "Content-Type"
        static let FormUrlEncoded = "application/x-www-form-urlencoded"
        static let JsonEncoded = "application/json"
        static let auth = "Authorization"
        static let authData = "Bearer "
        static let XRapidAPIHost = "X-RapidAPI-Host"
        static let XRapidAPIHostValue = "limoucloud.p.rapidapi.com"
        static let XRapidAPIKey = "X-RapidAPI-Key"
        static let XRapidAPIKeyValue = "98fefbef40mshb4bc22fa749b7a3p1f8476jsn219ced7f7bcf"
    }
    
    // MARK: - Custome Dates
    struct CustomDate {
        
        /// converting server date
        /// - Parameter date: date to be converted
        /// - Returns: returns date in 'dd.MM.yyyy - HH:MM'
        static  func getServerDate(_ date: String) -> String? {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            if let date = formatter.date(from: date) {
                formatter.dateFormat = DateFormates.appDateFormate.dateFormat
                formatter.timeZone = TimeZone(abbreviation: "UTC")
                return formatter.string(from: date)
            } else {
                return nil
            }
        }
        
        /// converts date from "yyyy-MM-dd" to 'dd.MM.yyyy - HH:MM'
        /// - Parameter date: date to be formatted
        /// - Returns: date in 'dd.MM.yyyy - HH:MM'
        static func getDate(_ date: String) -> String? {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let date = formatter.date(from: date) {
                formatter.dateFormat = DateFormates.appDateFormate.dateFormat
                formatter.timeZone = TimeZone(abbreviation: "UTC")
                return formatter.string(from: date)
            } else {
                return nil
            }
        }
        
        /// returns utc date
        /// - Parameters:
        ///   - date: date to be converted
        ///   - formate: formate for date
        /// - Returns: utc date
        static  func getUTCDate(_ date: String, _ formate: String = "dd.MM.yyyy HH:mm:ss") -> Date? {
            let formatter = DateFormatter()
            formatter.dateFormat = formate
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            if let date = formatter.date(from: date) {
                return date
            } else {
                return nil
            }
        }
        
        /// converts date to specific formate
        /// - Parameters:
        ///   - date: date to be converted
        ///   - dateFormat: date formate
        /// - Returns: date in defined formate
        static func getDate(_ date: String, _ dateFormat: String) -> String? {
            if let date = getUTCDate(date) {
                let formatter = DateFormatter()
                formatter.dateFormat = dateFormat
                return formatter.string(from: date)
            } else {
                return nil
            }
        }
        
        /// convert date from specifc formate to specific formate
        /// - Parameters:
        ///   - date: date to be converted
        ///   - serverDateFormat: server date formate
        ///   - dateFormat: date formate to be converted
        /// - Returns: date in specfic formate
        static func getDate(_ date: String, _ serverDateFormat: String, _ dateFormat: String) -> String? {
            let formatter = DateFormatter()
            formatter.dateFormat = serverDateFormat
            if let date = formatter.date(from: date) {
                formatter.dateFormat = dateFormat
                formatter.timeZone = TimeZone(abbreviation: "UTC")
                return formatter.string(from: date)
            } else {
                return nil
            }
        }
        
        /// converts date string to Date
        /// - Parameters:
        ///   - stringDate: string date to be converted
        ///   - formate: date formate to be converted
        ///   - isUTC: checks if it is utc
        /// - Returns: date
        static func dateStringToDate(_ stringDate: String, formate: String = "dd.MM.yyyy HH:mm:ss", _ isUTC: Bool = true) -> Date {
            // Converting date string to Date type
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = formate
            if isUTC {
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            }
            
            return dateFormatter.date(from: stringDate) ?? Date()
        }
        
        /// converts date string to Date gmt
        /// - Parameters:
        ///   - stringDate: string date to be converted
        ///   - formate: date formate to be converted
        ///   - isUTC: checks if it is utc
        /// - Returns: date
        static func dateStringToGMTDate(_ stringDate: String, formate: String = "dd.MM.yyyy HH:mm:ss") -> Date {
            // Converting date string to Date type
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = formate
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT +5")
            return dateFormatter.date(from: stringDate) ?? Date()
        }
    }
    
    // MARK: - Custome Date Formate
    struct DateFormates {
        // Date Formates
        static let appDateFormate: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy - HH:MM"
            return formatter
        }()
        
        static let birthDateFormate: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            return formatter
        }()
        
        static let calendarFormate: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM"
            return formatter
        }()
        
        static let fsCalenderFormate: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            return formatter
        }()
        
        static let displayFormate: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            return formatter
        }()
    }
}
