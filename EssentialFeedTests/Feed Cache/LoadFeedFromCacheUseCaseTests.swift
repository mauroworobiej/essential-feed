//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Mauro Worobiej on 22/09/2021.
//

import XCTest
import EssentialFeed

class LoadFeedFromCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.recivedMessages, [])
    }
    
    func test_load_requestCacheRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        
        XCTAssertEqual(store.recivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrivalError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(retrivalError)) {
            store.completeRetrival(with: retrivalError)
        }
    }
    
    func test_load_deliversNoImagesOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrivalWithEmptyCache()
        }
    }
    
    func test_load_deliversCachedImagesOnNonExpiredCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDay = Date()
        let nonExpiredTimestamp = fixedCurrentDay.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDay })
        
        expect(sut, toCompleteWith: .success(feed.model)) {
            store.completeRetrival(with: feed.local, timestamp: nonExpiredTimestamp)
        }
    }
    
    func test_load_deliversNoImagesOnCacheExpiration() {
        let feed = uniqueImageFeed()
        let fixedCurrentDay = Date()
        let expirationTimestamp = fixedCurrentDay.minusFeedCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDay })
        
        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrival(with: feed.local, timestamp: expirationTimestamp)
        }
    }
    
    func test_load_deliversNoImagesOnExpiredOldCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDay = Date()
        let expiredTimestamp = fixedCurrentDay.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDay })
        
        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrival(with: feed.local, timestamp: expiredTimestamp)
        }
    }
    
    func test_load_hasNoSideEffectsOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        
        store.completeRetrival(with: anyNSError())
        
        XCTAssertEqual(store.recivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        
        store.completeRetrivalWithEmptyCache()
        
        XCTAssertEqual(store.recivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnNonExpiredCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDay = Date()
        let noExpiredTimestamp = fixedCurrentDay.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDay })
        
        sut.load { _ in }
        
        store.completeRetrival(with: feed.local, timestamp: noExpiredTimestamp)
        
        XCTAssertEqual(store.recivedMessages, [.retrieve])
    }

    func test_load_hasNoSideEffectsOnCacheExpirattion() {
        let feed = uniqueImageFeed()
        let fixedCurrentDay = Date()
        let expirationTimestamp = fixedCurrentDay.minusFeedCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDay })
        
        sut.load { _ in }
        
        store.completeRetrival(with: feed.local, timestamp: expirationTimestamp)
        
        XCTAssertEqual(store.recivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnExpiredCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDay = Date()
        let expiredTimestamp = fixedCurrentDay.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDay })
        
        sut.load { _ in }
        
        store.completeRetrival(with: feed.local, timestamp: expiredTimestamp)
        
        XCTAssertEqual(store.recivedMessages, [.retrieve])
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        
        var recivedResult = [LocalFeedLoader.LoadResult]()
        sut?.load { recivedResult.append($0) }
        
        sut = nil
        store.completeRetrivalWithEmptyCache()
        
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
    
    private func expect(_ sut: LocalFeedLoader, toCompleteWith expectedResult: LocalFeedLoader.LoadResult, when action: () -> Void,  file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { rescivedResult in
            switch (rescivedResult, expectedResult) {
            case let (.success(recivedImage), .success(expectedImage)):
                XCTAssertEqual(recivedImage, expectedImage, file: file, line: line)
                
            case let (.failure(recivedError), .failure(expectedError)):
                XCTAssertEqual(recivedError as NSError, expectedError as NSError, file: file, line: line)
                
            default:
                XCTFail("Expected \(expectedResult), got \(rescivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
}
