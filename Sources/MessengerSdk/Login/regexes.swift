//
//  regexes.swift
//  
//
//  Created by Tomasz on 21/05/2021.
//

import Foundation

@available(iOS 13.0, *)
extension MessengerClient {
    
    /// MARK: - Regex
    private func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
            let finalResult = results.map {
                String(text[Range($0.range, in: text)!])
            }
            return finalResult
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
           }
        }
}
