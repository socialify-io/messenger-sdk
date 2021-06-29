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
    
    public init() {
        self.delegate = false ? Session() : nil
        self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: delegate, delegateQueue: nil)
    }
    
    public let LIBRARY_VERSION = "v0.0.1"
    
    public var delegate: Session?
    public var session: URLSession?
    
    public var clientID = ""
    
    
    /// MARK: - Messenger Errors
    
    public enum MessengerError: Error {
        case ConnectionError
        case ScrapperError
        case MessengerError
        case UnexpectedError
    }
}
