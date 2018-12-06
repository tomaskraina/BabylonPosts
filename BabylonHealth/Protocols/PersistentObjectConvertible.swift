//
//  PersistentObjectConvertible.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 06/12/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import RealmSwift

protocol PersistentObjectConvertible  {
    associatedtype ObjectType: RealmSwift.Object
    init(from object: ObjectType)
}
