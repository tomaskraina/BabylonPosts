//
//  DataProviderType.swift
//  BabylonPosts
//
//  Created by Tom Kraina on 16/12/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation
import RxSwift

protocol PostsProviderType {
    func requestPosts() -> Completable
    func allPosts() -> Observable<Posts>
}

protocol UsersProviderType {
    func requestUser(id: Identifier<User>) -> Completable
    func user(id: Identifier<User>) -> Observable<User>
}

protocol CommentsProviderType {
    func requestComments(postId: Identifier<Post>) -> Completable
    func commentCount(postId: Identifier<Post>) -> Observable<Int>
}

protocol DataProviderType: HasUsersProvider, HasCommentsProvider, HasPostsProvider {
    var posts: PostsProviderType { get }
    var users: UsersProviderType { get }
    var comments: CommentsProviderType { get }
    func deleteAllData() -> Observable<Void>
}
