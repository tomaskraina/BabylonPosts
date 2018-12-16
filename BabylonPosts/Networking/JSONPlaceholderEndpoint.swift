//
//  JSONPlaceholderEndpoint.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 30/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation

/// More info: http://jsonplaceholder.typicode.com
///
/// - posts: List of all posts
/// - users: List of all users
/// - comments: List of all comments for give post identifier
enum JSONPlaceholderEndpoint {
    case posts
    case users
    case user(id: Identifier<User>)
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
            
        case .users, .user:
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
            
        case let .user(id):
            return [
                "id": id.rawValue
            ]
            
        default:
            return nil
        }
    }
}
