//
//  DataProvider.swift
//  BabylonPosts
//
//  Created by Tom Kraina on 16/12/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation
import RxSwift


protocol PostsProvider {
    func requestPosts() -> Completable
    func allPosts() -> Observable<Posts>
}

protocol UsersProvider {
    func requestUser(id: Identifier<User>) -> Completable
    func user(id: Identifier<User>) -> Observable<User>
}

protocol CommentsProvider {
    func requestComments(postId: Identifier<Post>) -> Completable
    func commentCount(postId: Identifier<Post>) -> Observable<Int>
}

protocol DataProvidering: HasUsersProvider {
    var posts: PostsProvider { get }
    var users: UsersProvider { get }
    var comments: CommentsProvider { get }
    func deleteAllData() -> Observable<Void>
}

class DataProvider: DataProvidering, PostsProvider, UsersProvider, CommentsProvider {
    let apiClient: ApiClient
    let storage: PersistentStorage
    
    init(apiClient: ApiClient, storage: PersistentStorage) {
        self.apiClient = apiClient
        self.storage = storage
    }
    
    func allPosts() -> Observable<Posts> {
        return storage.posts()
    }
    
    func requestPosts() -> Completable {
        return Completable.create(subscribe: { [apiClient, storage] handler in
            return apiClient.requestPostList()
                .asObservable() // Convert to Observable so we can subscribe to it with storage.storePosts
                .do(onError: { handler(.error($0)) }, onCompleted: { handler(.completed)} )
                .subscribe(storage.storePosts { handler(.error($0)) })
        })
    }
    
    // MARK: - DataProvidering
    
    var posts: PostsProvider {
        return self
    }
    
    func deleteAllData() -> Observable<Void> {
        return Observable.create({ [storage] (observer) in
            storage.deleteAllData {
                observer.onError($0)
            }
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    // MARK: - UsersProvidering
    
    var users: UsersProvider {
        return self
    }
    
    func requestUser(id: Identifier<User>) -> Completable {
        return Completable.create { [apiClient, storage] (handler) in
            apiClient.requestUser(id: id)
                .map { [$0] }
                .asObservable()
                .do(onError: { handler(.error($0)) }, onCompleted: { handler(.completed)} )
                .subscribe(storage.storeUsers { handler(.error($0)) })
        }
    }
    
    func user(id: Identifier<User>) -> Observable<User> {
        return storage.user(id: id)
    }
    
    // MARK: - CommentsProvidering
    
    var comments: CommentsProvider {
        return self
    }
    
    func requestComments(postId: Identifier<Post>) -> Completable {
        return Completable.create { [apiClient, storage] (handler) in
            apiClient.requestComments(postId: postId)
                .asObservable()
                .do(onError: { handler(.error($0)) }, onCompleted: { handler(.completed)} )
                .subscribe(storage.storeComments { handler(.error($0)) })
        }
    }
    
    func commentCount(postId: Identifier<Post>) -> Observable<Int> {
        return storage.commentCount(for: postId)
    }
    
}
