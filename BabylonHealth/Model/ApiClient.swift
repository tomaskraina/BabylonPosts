//
//  ApiClient.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 30/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - Protocols

protocol ApiClient {
    func requestPostList() -> Observable<Posts>
    func requestUserList() -> Observable<Users>
    func requestComments(postId: Identifier<Post>) -> Observable<Comments>
}

// MARK: - Implementation

class JSONPlaceholderApiClient: ApiClient {
    
    init(networking: NetworkingProvider) {
        self.networking = networking
    }
    
    let networking: NetworkingProvider
    
    func requestPostList() -> Observable<Posts> {
        let endpoint = JSONPlaceholderEndpoint.posts
        return networking.request(endpoint: endpoint)
    }
    
    func requestUserList() -> Observable<Users> {
        let endpoint = JSONPlaceholderEndpoint.users
        return networking.request(endpoint: endpoint)
    }
    
    func requestComments(postId: Identifier<Post>) -> Observable<Comments> {
        let endpoint = JSONPlaceholderEndpoint.comments(postId: postId)
        return networking.request(endpoint: endpoint)
    }
}
