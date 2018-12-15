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
    func requestPostList() -> Single<Posts>
    func requestUserList() -> Single<Users>
    func requestUser(id: Identifier<User>) -> Single<User>
    func requestComments(postId: Identifier<Post>) -> Single<Comments>
}

enum ApiClientError: Error {
    case itemNotFound
    case other(underlyingError: Error)
}

// MARK: - Implementation

class JSONPlaceholderApiClient: ApiClient {
    
    init(networking: NetworkingProvider) {
        self.networking = networking
    }
    
    let networking: NetworkingProvider
    
    func requestPostList() -> Single<Posts> {
        let endpoint = JSONPlaceholderEndpoint.posts
        return networking.request(endpoint: endpoint)
            .map { (response: PostsResponse) in Array(response) }
    }
    
    func requestUserList() -> Single<Users> {
        let endpoint = JSONPlaceholderEndpoint.users
        return networking.request(endpoint: endpoint)
            .map { (response: UsersResponse) in Array(response) }
    }
    
    func requestUser(id: Identifier<User>) -> Single<User> {
        let endpoint = JSONPlaceholderEndpoint.user(id: id)
        let users: Single<UsersResponse> = networking.request(endpoint: endpoint)
        
        return users.flatMap({ (users) -> Single<User> in
            if let user = users.first(where: { $0.id == id }) {
                return Single.just(user)
            } else {
                return Single.error(ApiClientError.itemNotFound)
            }
        })
    }
    
    func requestComments(postId: Identifier<Post>) -> Single<Comments> {
        let endpoint = JSONPlaceholderEndpoint.comments(postId: postId)
        return networking.request(endpoint: endpoint)
            .map { (response: CommentsResponse) in Array(response) }
    }
}
