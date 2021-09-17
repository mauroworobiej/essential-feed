//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Mauro Worobiej on 15/09/2021.
//

import Foundation

public protocol FeedStore {
    typealias deletionCompletion = (Error?) -> Void
    typealias insertionCompletion = (Error?) -> Void
    
    func deleteCacheFeed(completion: @escaping deletionCompletion)
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping insertionCompletion)
}
