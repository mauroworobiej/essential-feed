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
    }
    
    private(set) var recivedMessages = [RecivedMessage]()
    
    private var deletionCompletions = [deletionCompletion]()
    private var insertionCompletions = [insertionCompletion]()
    
    func deleteCacheFeed(completion: @escaping deletionCompletion) {
        deletionCompletions.append(completion)
        recivedMessages.append(.deleteCacheFeed)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping insertionCompletion) {
        insertionCompletions.append(completion)
        recivedMessages.append(.insert(feed, timestamp))
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
}
