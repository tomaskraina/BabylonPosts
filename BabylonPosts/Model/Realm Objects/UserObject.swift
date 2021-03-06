//
//  UserObject.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 03/12/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation
import RealmSwift

class UserObject: Object {
    @objc dynamic public fileprivate(set) var id: Int = 0
    @objc dynamic public fileprivate(set) var name: String = ""
    @objc dynamic public fileprivate(set) var username: String = ""
    @objc dynamic public fileprivate(set) var email: String = ""
    
    // MARK: - Configuration
    override public static func primaryKey() -> String? {
        return "id"
    }
}

// MARK: - ItemUpdateable
extension UserObject: ItemUpdateable {
    
    typealias ItemType = User
    
    convenience init(item: ItemType, realm: Realm?) {
        self.init()
        
        self.id = item.id.rawValue
        update(with: item)
        
        realm?.add(self)
    }
    
    @discardableResult
    func update(with item: ItemType) -> Self {
        
        name = item.name
        username = item.username
        email = item.email
        
        return self
    }
}

// MARK: - PersistentObjectConvertible
extension User: PersistentObjectConvertible {
    typealias ObjectType = UserObject
    
    init(from object: ObjectType) {
        self.init(
            id: Identifier<User>(rawValue: object.id),
            name: object.name,
            username: object.username,
            email: object.email
        )
    }
    
    func persistentObject() -> ObjectType {
        return ObjectType(item: self, realm: nil)
    }
}
