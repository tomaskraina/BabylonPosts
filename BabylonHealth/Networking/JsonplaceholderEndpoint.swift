//
//  JSONPlaceholderEndpoint.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 30/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Alamofire

// Inspired by: http://chris.eidhof.nl/posts/typesafe-url-routes-in-swift.html

// MARK: - Protocols

public protocol Path {
    var path : String { get }
}

public protocol Endpoint: Path, URLConvertible {
    var baseURL: URL { get }
    var method: Alamofire.HTTPMethod { get }
    var parameters: [String: Any]? { get }
}

// MARK: - Endpoint + default implementation
extension Endpoint {
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    func asURL() throws -> URL {
        guard let url = URL(string: path, relativeTo: baseURL) else { throw AFError.invalidURL(url: self) }
        return url
    }
}

// MARK: - JSONPlaceholderEndpoint

/// More info: http://jsonplaceholder.typicode.com
///
/// - posts: List of all posts
/// - users: List of all users
/// - comments: List of all comments for give post identifier
enum JSONPlaceholderEndpoint {
    case posts
    case users
    case comments(postId: Identifier<Post>)
}

// MARK: - JSONPlaceholderEndpoint+Endpoint
extension JSONPlaceholderEndpoint: Endpoint {
    
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com/")!
    }
    
    var path: String {
        switch self {
        case .posts:
            return "posts"
            
        case .users:
            return "users"
            
        case .comments:
            return "comments"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case let .comments(postId):
            return [
                "postId": postId.rawValue
            ]
            
        default:
            return nil
        }
    }
}
