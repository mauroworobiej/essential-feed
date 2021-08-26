//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Mauro Worobiej on 26/08/2021.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
