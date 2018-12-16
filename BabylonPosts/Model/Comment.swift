//
//  Comment.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 30/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation

typealias CommentsResponse = SafelyDecodableArray<Comment>

typealias Comments = [Comment]

struct Comment: Codable, Identifiable, Equatable, Hashable {
    let id: Identifier<Comment>
    let postID: Identifier<Post>
    let name, email, body: String
    
    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case id, name, email, body
    }
}
