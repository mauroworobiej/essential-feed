//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Mauro Worobiej on 21/08/2021.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
