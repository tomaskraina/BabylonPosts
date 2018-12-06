//
//  ItemUpdateable.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 06/12/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation

protocol ItemUpdateable: AnyObject {
    associatedtype ItemType
    func update(with item: ItemType) -> Self
}
