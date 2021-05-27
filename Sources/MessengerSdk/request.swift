//
//  request.swift
//  
//
//  Created by Tomasz on 19/05/2021.
//

import Foundation
import Combine
import SwiftSoup

@available(iOS 13.0, *)
extension MessengerClient {
    func _request(request: URLRequest, completion: @escaping (Result<Data, MessengerError>) -> Void) {
        var request = request
        request.addValue("Socialify - MessengerSdk \(LIBRARY_VERSION)", forHTTPHeaderField: "User-Agent")
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                  if let _ = error {
                    completion(.failure(MessengerError.ConnectionError))
                  }
                
                completion(.failure(MessengerError.ConnectionError))
                return
                }
            
            completion(.success(data))
        }.resume()
    }
}
