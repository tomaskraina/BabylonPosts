//
//  PostObject.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 03/12/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation
import RealmSwift

class PostObject: Object {
    @objc dynamic public fileprivate(set) var id: Int = 0
    @objc dynamic public fileprivate(set) var userId: Int = 0
    @objc dynamic public fileprivate(set) var title: String = ""
    @objc dynamic public fileprivate(set) var body: String = ""
    
    // MARK: - Configuration
    override public static func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - ItemUpdateable
extension PostObject: ItemUpdateable {
    
    typealias ItemType = Post
    
    convenience init(item: ItemType, realm: Realm?) {
        self.init()
        
        self.id = item.id.rawValue
        update(with: item)
        
        realm?.add(self)
    }
    
    @discardableResult
    func update(with item: ItemType) -> Self {
        
        userId = item.userID.rawValue
        title = item.title
        body = item.body
        
        return self
    }
}

// MARK: - PersistentObjectConvertible
extension Post: PersistentObjectConvertible {
    typealias ObjectType = PostObject
    
    init(from object: ObjectType) {
        self.init(
            id: Identifier<Post>(rawValue: object.id),
            userID: Identifier<User>(rawValue: object.userId),
            title: object.title,
            body: object.body
        )
    }
    
    func persistentObject() -> ObjectType {
        return ObjectType(item: self, realm: nil)
    }
}
