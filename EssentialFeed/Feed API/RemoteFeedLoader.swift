//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Mauro Worobiej on 22/08/2021.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Error?,  HTTPURLResponse?) -> Void)
}

public final class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Error) -> Void) {
        client.get(from: url) { error, response in
            if response == nil {
                completion(.connectivity)
            } else {
                completion(.invalidData)
            }
        }
    }
}
