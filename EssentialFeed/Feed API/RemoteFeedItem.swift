//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Mauro Worobiej on 16/09/2021.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
