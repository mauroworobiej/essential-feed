//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Mauro Worobiej on 12/09/2021.
//

import XCTest
import EssentialFeed

class CacheFeedUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.recivedMessages, [])
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        
        sut.save(uniqueImageFeed().model) { _ in }
        
        XCTAssertEqual(store.recivedMessages, [.deleteCacheFeed])
    }
    
    func test_save_doesNotRequestsCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        sut.save(uniqueImageFeed().model) { _ in }
        
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.recivedMessages, [.deleteCacheFeed])
    }
    
    func test_save_requestNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
        let timestamp = Date()
        let (sut, store) = makeSUT(currentDate: { timestamp })
        let feed = uniqueImageFeed()
        
        sut.save(feed.model) { _ in }
        
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.recivedMessages, [.deleteCacheFeed, .insert(feed.local, timestamp)])
    }
    
    func test_save_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        expect(sut, toCompletWith: deletionError) {
            store.completeDeletion(with: deletionError)
        }
    }
    
    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        
        let insertionError = anyNSError()
        
        expect(sut, toCompletWith: insertionError) {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        }
    }
    
    func test_save_succedsOnSuccessfulCacheInsertionError() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompletWith: nil) {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        }
    }
    
    func test_save_doesNotDeliverDeletionErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        
        var recivedResult = [LocalFeedLoader.SaveResult]()
        sut?.save(uniqueImageFeed().model) { recivedResult.append($0) }
        
        sut = nil
        store.completeDeletion(with: anyNSError())
        
        XCTAssertTrue(recivedResult.isEmpty)
    }
    
    func test_save_doesNotDeliverInsertionErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        
        var recivedResult = [LocalFeedLoader.SaveResult]()
        sut?.save(uniqueImageFeed().model) { recivedResult.append($0) }
        
        store.completeDeletionSuccessfully()
        sut = nil
        store.completeInsertion(with: anyNSError())
        
        XCTAssertTrue(recivedResult.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut: sut, store: store)
    }
    
    private func expect(_ sut: LocalFeedLoader, toCompletWith expectedError: NSError?, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for save completion")
        
        var recivedError: Error?
        
        sut.save(uniqueImageFeed().model) { error in
            if error != nil {
                recivedError = error
            }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(recivedError as NSError?, expectedError, file: file, line: line)
    }
    
    private class FeedStoreSpy: FeedStore {
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
    
    private func uniqueImage() -> FeedImage {
        FeedImage(id: UUID(), description: "Any", location: "Any", url: anyURL())
    }
    
    private func uniqueImageFeed() -> (model: [FeedImage], local: [LocalFeedImage]) {
        let model = [uniqueImage(), uniqueImage()]
        let local = model.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
        return (model, local)
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
}
