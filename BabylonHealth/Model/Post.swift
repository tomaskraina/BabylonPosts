//
//  Post.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 30/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation

typealias Posts = [Post]

struct Post: Codable, Identifiable, Equatable, Hashable {
    let id: Identifier<Post>
    let userID: Identifier<User>
    let title, body: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}
