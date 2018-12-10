//
//  RealmPersistantStorage.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 05/12/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation
import RxSwift
import RxRealm
import RealmSwift


protocol PersistentStorage {
    func posts() -> Observable<Posts>
    func storePosts(onError: ((LocalizedError) -> Void)?) -> AnyObserver<Posts>
    
    func user(id: Identifier<User>) -> Observable<User>
    func storeUsers(onError: ((LocalizedError) -> Void)?) -> RxSwift.AnyObserver<Users>
    
    func comments(for postId: Identifier<Post>) -> Observable<Comments>
    func commentCount(for postId: Identifier<Post>) -> Observable<Int>
    func storeComments(onError: ((LocalizedError) -> Void)?) -> RxSwift.AnyObserver<Comments>
    
    func deleteAllData(onError: ((LocalizedError) -> Void)?)
}

class RealmPersistantStorage: PersistentStorage {

    enum Error: LocalizedError {
        case realmFailedToInitiate(error: Swift.Error)
        case realmFailedToWrite(error: Swift.Error)
    }
    
    init(configuration: Realm.Configuration = .defaultConfiguration) {
        self.configuration = configuration
    }
    
    var configuration: Realm.Configuration
    
    func posts() -> Observable<Posts> {

        return withRealm({ realm in
            let postObjects = realm.objects(PostObject.self)
                .sorted(byKeyPath: "id", ascending: false)
            
            let postsObservable = Observable
                .array(from: postObjects, synchronousStart: true)  // synchronousStart - better for UI
                .map({ $0.map(Post.init(from:)) })
            
            return postsObservable
        }, else: { Observable.error($0) })
    }
    
    func storePosts(onError: ((LocalizedError) -> Void)? = nil) -> RxSwift.AnyObserver<Posts> {
        return withRealm({ realm in
            return realm.rx.add(update: true)
                .mapObserver { $0.map { $0.persistentObject() }}
        }, else: {
            onError?($0)
            return AnyObserver(eventHandler: { _ in })
        })
    }
    
    // MARK: - Users
    
    func users() -> Observable<Users> {
        return withRealm({ realm in
            let objects = realm.objects(UserObject.self)
            
            let observable = Observable
                .array(from: objects, synchronousStart: true)
                .map{ $0.map(User.init(from:)) }
            
            return observable
        }, else: { Observable.error($0) })
    }
    
    func user(id: Identifier<User>) -> Observable<User> {
        return withRealm({ realm in
            let predicate = NSPredicate(format: "id = %d", id.rawValue)
            let objects = realm.objects(UserObject.self)
                .filter(predicate)
            
            let observable = Observable
                .array(from: objects, synchronousStart: true)
                .map { $0.first }
                .filter { $0 != nil }
                .map { $0! }
                .map(User.init(from:))
            
            return observable
        }, else: { Observable.error($0) })
    }
    
    func storeUsers(onError: ((LocalizedError) -> Void)? = nil) -> RxSwift.AnyObserver<Users> {
        
        return withRealm({ realm in
            return realm.rx.add(update: true, onError: { (s, error) in onError?(Error.realmFailedToWrite(error: error as NSError)) })
                .mapObserver { $0.map { $0.persistentObject() } }
            
        }, else: { error in
            onError?(error)
            return AnyObserver(eventHandler: { _ in })
        })
    }
    
    // MARK: - Comments
    
    func commentCount(for postId: Identifier<Post>) -> Observable<Int> {
        return withRealm({ realm in
            let predicate = NSPredicate(format: "postId = %d", postId.rawValue)
            let objects = realm.objects(CommentObject.self).filter(predicate)
            
            let observable = Observable.collection(from: objects)
                .map({ $0.count })
            
            return observable
        }, else: { Observable.error($0) })
    }
    
    func comments(for postId: Identifier<Post>) -> Observable<Comments> {
        return withRealm({ realm in
            let predicate = NSPredicate(format: "postId = %d", postId.rawValue)
            let objects = realm.objects(CommentObject.self)
                .filter(predicate)
            
            let observable = Observable
                .array(from: objects, synchronousStart: true)
                .map{ $0.map(Comment.init(from:)) }
            
            return observable
        }, else: { Observable.error($0) })
    }
    
    func storeComments(onError: ((LocalizedError) -> Void)? = nil) -> RxSwift.AnyObserver<Comments> {
        
        return withRealm({ realm in
            return realm.rx.add(update: true, onError: { (s, error) in onError?(Error.realmFailedToWrite(error: error)) })
                .mapObserver { $0.map { $0.persistentObject() } }
            
        }, else: { error in
            onError?(error)
            return AnyObserver(eventHandler: { _ in })
        })
    }
    
    // MARK: - Deletion
    
    func deleteAllData(onError: ((LocalizedError) -> Void)? = nil) {
        
        withRealm({ realm -> Void in
            do {
                try realm.write {
                    realm.deleteAll()
                }
            } catch {
                onError?(RealmPersistantStorage.Error.realmFailedToWrite(error: error))
            }
        }, else: { onError?($0) })
    }
    
    // MARK: - Privates
    
    private func withRealm<T>(_ block: (Realm) -> T, else onError: (RealmPersistantStorage.Error) -> T ) -> T {
        
        do {
            let realm = try Realm.init(configuration: configuration)
            return block(realm)
        } catch {
            return onError(RealmPersistantStorage.Error.realmFailedToInitiate(error: error))
        }
    }
}
