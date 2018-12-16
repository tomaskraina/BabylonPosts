//
//  MockDataProvider.swift
//  BabylonPostsTests
//
//  Created by Tom Kraina on 16/12/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation
import RxSwift
@testable import BabylonPosts

struct MockDataProvider: HasDataProvider, DataProviderType, UsersProviderType, PostsProviderType, CommentsProviderType {
    
    var dataProvider: DataProviderType {
        return self
    }
    
    var posts: PostsProviderType {
        return self
    }
    
    var users: UsersProviderType {
        return self
    }
    
    var comments: CommentsProviderType {
        return self
    }
    
    var onDeleteAllData: (() -> Void)?
    
    func deleteAllData() -> Completable {
        onDeleteAllData?()
        return .empty()
    }
    
    var onRequestUserId: ((Identifier<User>) -> Void)?
    
    func requestUser(id: Identifier<User>) -> Completable {
        onRequestUserId?(id)
        return .empty()
    }
    
    var userObservable: Observable<User>
    
    func user(id: Identifier<User>) -> Observable<User> {
        return userObservable
    }
    
    var onRequestPosts: (() -> Void)?
    
    func requestPosts() -> Completable {
        onRequestPosts?()
        return .empty()
    }
    
    var postsObservable: Observable<Posts>
    
    func allPosts() -> Observable<Posts> {
        return postsObservable
    }
    
    var onRequestComments: ((Identifier<Post>) -> Void)?
    
    func requestComments(postId: Identifier<Post>) -> Completable {
        onRequestComments?(postId)
        return .empty()
    }
    
    var commentCountObservable: Observable<Int>
    
    func commentCount(postId: Identifier<Post>) -> Observable<Int> {
        return commentCountObservable
    }
}
