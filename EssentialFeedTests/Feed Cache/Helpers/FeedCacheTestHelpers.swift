//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Mauro Worobiej on 26/09/2021.
//

import Foundation
import EssentialFeed

func uniqueImage() -> FeedImage {
    FeedImage(id: UUID(), description: "Any", location: "Any", url: anyURL())
}

func uniqueImageFeed() -> (model: [FeedImage], local: [LocalFeedImage]) {
    let model = [uniqueImage(), uniqueImage()]
    let local = model.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    return (model, local)
}

extension Date {
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
