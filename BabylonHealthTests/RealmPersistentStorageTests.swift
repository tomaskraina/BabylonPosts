//
//  RealmPersistentStorageTests.swift
//  BabylonHealthTests
//
//  Created by Tom Kraina on 18/11/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import XCTest
@testable import BabylonHealth

class RealmPersistentStorageTests: XCTestCase {

    func testStoreAndRetrievePosts() throws {
        
        // Given
        let posts: Posts = try JSON(named: "posts")
        
        // When
        let storage = RealmPersistantStorage()
        storage.storePosts().onNext(posts)
        
        // Then
        let storage2 = RealmPersistantStorage()
        let result = try storage2.posts()
            .toBlocking(timeout: 1)
            .first()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 100)
    }
    
    func testStoreAndRetrieveUsers() throws {
        
        // Given
        let users: Users = try JSON(named: "users")
        
        // When
        let storage = RealmPersistantStorage()
        storage.storeUsers().onNext(users)
        
        // Then
        let storage2 = RealmPersistantStorage()
        let result = try storage2.users()
            .toBlocking(timeout: 1)
            .first()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 10)
    }

    
    func testStoreAndRetrieveComments() throws {
        
        // Given
        let comments: Comments = try JSON(named: "comments")
        
        // When
        let storage = RealmPersistantStorage()
        storage.storeComments().onNext(comments)
        
        // Then
        let storage2 = RealmPersistantStorage()
        let result = try storage2.commentCount(for: 1)
            .toBlocking(timeout: 1)
            .first()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result, 5)
    }
}
