//
//  PostTableViewCellModel.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 01/11/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation

protocol PostTableViewCellModelling {
    var title: String { get }
}

class PostTableViewCellModel: PostTableViewCellModelling {
    
    let post: Post
    
    init(post: Post) {
        self.post = post
    }
    
    var title: String {
        return post.title
    }
}
