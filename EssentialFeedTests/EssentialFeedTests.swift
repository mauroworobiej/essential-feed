//
//  EssentialFeedTests.swift
//  EssentialFeedTests
//
//  Created by Mauro Worobiej on 21/08/2021.
//

import XCTest
@testable import EssentialFeed

class RemoteFeedLoaderTest: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(client: client, url: URL(string: "http://a-url.com")!)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HTTPClientSpy()
        let url = URL(string: "http://a-url.com")!
        let sut = RemoteFeedLoader(client: client, url: url)
        
        sut.load()
        XCTAssertEqual(client.requestedURL, url)
    }
    
    // MARK: Helper methods
    
    private func makeSUT() {}
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    func get(from url: URL) {
        self.requestedURL = url
    }
}


protocol HTTPClient {
    func get(from url: URL)
}

class RemoteFeedLoader {
    let client: HTTPClient
    let url: URL
    
    init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    func load() {
        client.get(from: url)
    }
}
