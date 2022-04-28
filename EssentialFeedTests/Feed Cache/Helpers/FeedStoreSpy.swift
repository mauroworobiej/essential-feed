//
//  FeedStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Mauro Worobiej on 22/09/2021.
//

import Foundation
import EssentialFeed

class FeedStoreSpy: FeedStore {
    enum RecivedMessage: Equatable {
        case deleteCacheFeed
        case insert([LocalFeedImage], Date)
        case retrieve
    }
    
    private(set) var recivedMessages = [RecivedMessage]()
    
    private var deletionCompletions = [DeletionCompletion]()
    private var insertionCompletions = [InsertionCompletion]()
    private var retrivalCompletions = [RetrievalCompletion]()
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        recivedMessages.append(.deleteCacheFeed)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
        recivedMessages.append(.insert(feed, timestamp))
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        retrivalCompletions.append(completion)
        recivedMessages.append(.retrieve)
    }
    
    func completeRetrival(with error: Error, at index: Int = 0) {
        retrivalCompletions[index](.failure(error))
    }
    
    func completeRetrivalWithEmptyCache(at index: Int = 0) {
        retrivalCompletions[index](.success(.empty))
    }
    
    func completeRetrival(with feed: [LocalFeedImage], timestamp: Date, at index: Int = 0) {
        retrivalCompletions[index](.success(.found(feed: feed, timestamp: timestamp)))
    }
}
