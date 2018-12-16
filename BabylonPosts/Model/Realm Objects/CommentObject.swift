//
//  CommentObject.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 03/12/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation
import RealmSwift

class CommentObject: Object {
    @objc dynamic public fileprivate(set) var id: Int = 0
    @objc dynamic public fileprivate(set) var postId: Int = 0
    @objc dynamic public fileprivate(set) var name: String = ""
    @objc dynamic public fileprivate(set) var email: String = ""
    @objc dynamic public fileprivate(set) var body: String = ""
    
    // MARK: - Configuration
    override public static func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - ItemUpdateable
extension CommentObject: ItemUpdateable {
    
    typealias ItemType = Comment
    
    convenience init(item: ItemType, realm: Realm?) {
        self.init()
        
        self.id = item.id.rawValue
        update(with: item)
        
        realm?.add(self)
    }
    
    @discardableResult
    func update(with item: ItemType) -> Self {
        
        postId = item.postID.rawValue
        name = item.name
        email = item.email
        body = item.body
        
        return self
    }
}

// MARK: - PersistentObjectConvertible
extension Comment {
    typealias ObjectType = CommentObject
    
    init(from object: ObjectType) {
        self.init(
            id: Identifier<Comment>(rawValue: object.id),
            postID: Identifier<Post>(rawValue: object.postId),
            name: object.name,
            email: object.email,
            body: object.body
        )
    }
    
    func persistentObject() -> ObjectType {
        return ObjectType(item: self, realm: nil)
    }
}
