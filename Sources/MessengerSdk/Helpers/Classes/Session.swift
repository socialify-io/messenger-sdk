//
//  Session.swift
//  
//
//  Created by Tomasz on 21/06/2021.
//

import Foundation

/// MARK: - Helper classes

public class Session: NSObject, URLSessionTaskDelegate {

    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(nil)
    }
}
