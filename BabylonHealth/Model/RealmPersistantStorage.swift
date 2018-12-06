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
}

class RealmPersistantStorage: PersistentStorage {
    
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
            .mapObserver { $0.map { PostObject(item: $0, realm: nil) }}
    }
    
    func deletePosts() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
}

