//
//  MessengerClient.swift
//
//
//  Created by Tomasz on 10/05/2021.
//


import Foundation

@available(iOS 13.0, *)
public class MessengerClient {
    
    /// MARK: - Public variables
    
    public init() {}
    
    public let LIBRARY_VERSION = "v0.0.1"
    public let session = URLSession.shared
    
    
    /// MARK: - Messenger Errors
    
    public enum MessengerError: Error {
        case ConnectionError
        case ScrapperError
        case MessengerError
        case UnexpectedError
    }
}
