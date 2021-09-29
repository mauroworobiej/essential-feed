//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Mauro Worobiej on 29/09/2021.
//

import Foundation

final class FeedCachePolicy {
    
    private init() {}
    
    private static let calendar = Calendar(identifier: .gregorian)
    
    private static var maxCacheInAgeDays: Int {
        return 7
    }
    
    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxAge = calendar.date(byAdding: .day, value: maxCacheInAgeDays, to: timestamp) else {
            return false
        }
        
        return date < maxAge
    }
}
