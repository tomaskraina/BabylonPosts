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
    func storePosts() -> AnyObserver<Posts>
    func deletePosts()
    
    func user(id: Identifier<User>) -> Observable<User>
    func storeUsers() -> RxSwift.AnyObserver<Users>
    
    func comments(for postId: Identifier<Post>) -> Observable<Comments>
    func commentCount(for postId: Identifier<Post>) -> Observable<Int>
    func storeComments() -> RxSwift.AnyObserver<Comments>
}

class RealmPersistantStorage: PersistentStorage {

    // TODO: Handle Realm errors
    
    func posts() -> Observable<Posts> {
        let realm = try! Realm()
        let postObjects = realm.objects(PostObject.self)
            .sorted(byKeyPath: "id", ascending: false)
        
        let postsObservable = Observable
            .array(from: postObjects, synchronousStart: true)  // synchronousStart - better for UI
            .map({ $0.map(Post.init(from:)) })
        
        return postsObservable
    }
    
    func storePosts() -> RxSwift.AnyObserver<Posts> {
        let realm = try! Realm()
        return realm.rx.add(update: true)
            .mapObserver { $0.map { $0.persistentObject() }}
    }
    
    func deletePosts() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    // MARK: - Users
    
    func users() -> Observable<Users> {
        let realm = try! Realm()
        let objects = realm.objects(UserObject.self)
        
        let observable = Observable
            .array(from: objects, synchronousStart: true)
            .map{ $0.map(User.init(from:)) }
        
        return observable
    }
    
    func user(id: Identifier<User>) -> Observable<User> {
        let realm = try! Realm()
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
    }
    
    func storeUsers() -> RxSwift.AnyObserver<Users> {
        let realm = try! Realm()
        return realm.rx.add(update: true)
            .mapObserver { $0.map { $0.persistentObject() }}
    }
    
    // MARK: - Comments
    
    func commentCount(for postId: Identifier<Post>) -> Observable<Int> {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "postId = %d", postId.rawValue)
        let objects = realm.objects(CommentObject.self).filter(predicate)
        
        let observable = Observable.collection(from: objects)
            .map({ $0.count })
        
        return observable
    }
    
    func comments(for postId: Identifier<Post>) -> Observable<Comments> {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "postId = %d", postId.rawValue)
        let objects = realm.objects(CommentObject.self).filter(predicate)
        
        let observable = Observable
            .array(from: objects, synchronousStart: true)
            .map{ $0.map(Comment.init(from:)) }
        
        return observable
    }
    
    func storeComments() -> RxSwift.AnyObserver<Comments> {
        let realm = try! Realm()
        return realm.rx.add(update: true)
            .mapObserver { $0.map { $0.persistentObject() }}
    }
}

