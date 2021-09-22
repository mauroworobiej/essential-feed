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
        let exp = expectation(description: "Wait for load completion")
        
        var recivedError: Error?
        sut.load { result in
            switch result {
            case let .failure(error):
                recivedError = error
            default:
                XCTFail("Expected failure, got \(result) instead")

            }
            exp.fulfill()
        }
        
        store.completeRetrival(with: retrivalError)
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(recivedError as NSError?, retrivalError)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut: sut, store: store)
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
}
