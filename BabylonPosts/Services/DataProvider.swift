//
//  DataProvider.swift
//  BabylonPosts
//
//  Created by Tom Kraina on 16/12/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation
import RxSwift

/// This class is orchestrating the data flow from api client to persistent storage
class DataProvider {
    
    let apiClient: ApiClientType
    let storage: StorageType
    
    init(apiClient: ApiClientType, storage: StorageType) {
        self.apiClient = apiClient
        self.storage = storage
    }
}

// MARK: - DataProviderType
extension DataProvider: DataProviderType {
    var posts: PostsProviderType {
        return self
    }
    
    var users: UsersProviderType {
        return self
    }
    
    var comments: CommentsProviderType {
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
}

// MARK: - PostsProviderType
extension DataProvider: PostsProviderType {
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
}
    
// MARK: - UsersProviderType
extension DataProvider: UsersProviderType {
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
}
    
// MARK: - CommentsProviderType
extension DataProvider: CommentsProviderType {
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
