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

protocol DataProvidering {
    var posts: PostsProvider { get }
    func deleteAllData() -> Observable<Void>
}

class DataProvider: DataProvidering, PostsProvider {
    
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
}
