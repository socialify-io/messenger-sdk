//
//  requestHelpers.swift
//  
//
//  Created by Tomasz on 19/05/2021.
//

import Foundation

@available(iOS 13.0, *)
extension MessengerClient {
    
    /// MARK: - Request helpers
    func makeRequest(request: URLRequest, completion: @escaping (Result<Data, MessengerError>) -> Void) {
        var request = request
        request.addValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36", forHTTPHeaderField: "User-Agent")
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
