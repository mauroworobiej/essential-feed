//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Mauro Worobiej on 21/08/2021.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
