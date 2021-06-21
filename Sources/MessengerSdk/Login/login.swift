//
//  login.swift
//  
//
//  Created by Tomasz on 20/06/2021.
//

import Foundation
import SwiftSoup

@available(iOS 13.0, *)
extension MessengerClient {
    
    /// MARK: - Logging in functions
    
    /// Logging in
    /// Parameters:
    ///  - email
    ///  - password
    /// Returns
    /// - True or false

    public func login(email: String, password: String, completion: @escaping (Result<Bool, MessengerError>) -> Void) {
        // Getting params to log in
        getParams(email: email, password: password) { response in
            switch response {
            case .success(let payload):
                // Preparing a request
                let url = URL(string: "https://www.messenger.com/login/password")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = Data(payload.map { "\($0.key)=\($0.value)" }.joined(separator: "&").utf8)
                
                request.allHTTPHeaderFields = [
                    "Host": "www.messenger.com",
                    "Upgrade-Insecure-Requests": "1",
                    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
                    "Sec-Fetch-Site": "none",
                    "Sec-Fetch-Mode": "navigate",
                    "Sec-Fetch-User": "?1",
                    "Sec-Fetch-Dest": "document",
                    "Sec-Ch-Ua": "\"Chromium\";v=\"91\", \" Not;A Brand\";v=\"99\"",
                    "Sec-Ch-Ua-Mobile": "?0",
                    "Accept-Encoding": "gzip, deflate",
                    "Accept-Language": "en-GB,en-US;q=0.9,en;q=0.8",
                    "Connection": "close"
                ]
                
                // Sending request
                self.makeRequest(request: request) { result in
                    switch result {
                    case .success(let result):
                        let response = result["response"]
                        if let response = response as? HTTPURLResponse {
                            // Checking is logged in
                            let content: String = String(data: result["data"] as! Data, encoding: String.Encoding.utf8) ?? ""
                            print(content)
                            if content.contains("clientID") {
                                // Getting clientID
                                let regex = "\"clientID\":\"[a-z-0-9]{36}\""
                                self.clientID = self.matches(for: regex, in: content)[0]
                                    .replacingOccurrences(of: "\"clientID\":\"", with: "")
                                    .replacingOccurrences(of: "\"", with: "")

                                completion(.success(true))
                            } else if content.contains("Sorry, something went wrong.") {
                                completion(.failure(MessengerError.MessengerError))
                            } else {
                                completion(.success(false))
                            }
                        }
                    
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Getting required parameters to log in
    /// Parameters:
    ///  - email
    ///  - password
    /// Returns:
    ///  - jazoest - I don't know what the fuck is this, probably useless, but I scrapping it, because why not
    ///  - lsd - some letters, I don't know what is this like *jazoest*
    ///  - initial_request_id  - something like session id I think, but actualy not
    ///  - timezone - timezone, it's not important
    ///  - lgndim - information about your(my, because I hardcoded this) monitor encoded in base64, not important
    ///  - lgnrnd - some numbers and letters, I don't know what the fuck is this too
    ///  - lgnjs - character "n" - why "n"? I don't know
    ///  - email - your email
    ///  - pass - your password
    ///  - login - character "1", I don't know what it means
    ///  - default_persistent - something like cookies expires time, it can be empty
    
    private func getParams(email: String, password: String, completion: @escaping (Result<[String: Any], MessengerError>) -> Void) {
        // Names of inpust for scrapping
        let requiredInputs = ["jazoest", "lsd", "initial_request_id", "timezone", "lgnrnd", "lgnjs", "default_persistent"]
        
        // Declaring a variable with payload
        var payload: [String: Any] = [
            "jazoest": "",
            "lsd": "",
            "initial_request_id": "",
            "timezone": "-120",
            "lgndim": "eyJ3IjoxNDQwLCJoIjo5MDAsImF3IjoxNDQwLCJhaCI6ODc1LCJjIjozMH0%3D",
            "lgnrnd": "",
            "lgnjs": "n",
            "email": email,
            "pass": password,
            "login": "1",
            "default_persistent": ""
        ]

        // Preparing request
        let url = URL(string: "https://www.messenger.com/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.allHTTPHeaderFields = [
            "Host": "www.messenger.com",
            "Upgrade-Insecure-Requests": "1",
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
            "Sec-Fetch-Site": "none",
            "Sec-Fetch-Mode": "navigate",
            "Sec-Fetch-User": "?1",
            "Sec-Fetch-Dest": "document",
            "Sec-Ch-Ua": "\"Chromium\";v=\"91\", \" Not;A Brand\";v=\"99\"",
            "Sec-Ch-Ua-Mobile": "?0",
            "Accept-Encoding": "gzip, deflate",
            "Accept-Language": "en-GB,en-US;q=0.9,en;q=0.8",
            "Connection": "close"
        ]
        
        // Sending request
        self.makeRequest(request: request) { response in
            switch response {
            case .success(let response):
                // Parsing response
                let content: String = String(data: response["data"] as! Data, encoding: String.Encoding.utf8) ?? ""
                
                if content.contains("Sorry, something went wrong.") {
                    completion(.failure(MessengerError.MessengerError))
                }
                
                do {
                    let doc: Document = try SwiftSoup.parse(content)
                    
                    // Getting inputs
                    let inputs = try doc.select("input")
                    
                    // Scrapping inputs
                    try inputs.forEach { input in
                        if (requiredInputs.contains(try input.attr("name"))) {
                            payload[try input.attr("name")] = try input.attr("value")
                        }
                    }
                    
                    completion(.success(payload))
                } catch {
                    completion(.failure(MessengerError.ScrapperError))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
