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
    func insert(_ items: [LocalFeedItem], timestamp: Date, completion: @escaping insertionCompletion)
}

public struct LocalFeedItem: Equatable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let imageURL: URL
    
    public init(id: UUID, description: String?, location: String?, imageURL: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = imageURL
    }
}
