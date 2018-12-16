//
//  RealmPersistentStorageTests.swift
//  BabylonHealthTests
//
//  Created by Tom Kraina on 18/11/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import XCTest
@testable import BabylonPosts
import RealmSwift
import RxSwift

class RealmPersistentStorageTests: XCTestCase {

    override class func setUp() {
        // Use in-memory database for testing instead of the default one
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "com.tomkraina.BabylonHealtTests.inMemory"
    }
    
    override func setUp() {
        super.setUp()
        
        // Delete all data in Realm before each test case
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    
    func testStoreAndRetrievePosts() throws {
        
        // Given
        let posts: Posts = try JSON(named: "posts")
        let storage: StorageType = RealmPersistantStorage()
        let storage2: StorageType = RealmPersistantStorage()
        
        // When
        storage.storePosts(onError: nil).onNext(posts)
        
        // Then
        let result = try storage2.posts()
            .toBlocking(timeout: 1)
            .first()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 100)
    }
    
    func testStoreAndRetrieveUsers() throws {
        
        // Given
        let users: Users = try JSON(named: "users")
        let storage: StorageType = RealmPersistantStorage()
        let storage2: StorageType = RealmPersistantStorage()
        
        // When
        storage.storeUsers(onError: nil).onNext(users)
        
        // Then
        let result = try storage2.user(id: 1)
            .toBlocking(timeout: 1)
            .first()
        
        XCTAssertNotNil(result)
    }

    
    func testStoreAndRetrieveComments() throws {
        
        // Given
        let comments: Comments = try JSON(named: "comments")
        let storage: StorageType = RealmPersistantStorage()
        let storage2: StorageType = RealmPersistantStorage()
        
        // When
        storage.storeComments(onError: nil).onNext(comments)
        
        // Then
        let result = try storage2.commentCount(for: 1)
            .toBlocking(timeout: 1)
            .first()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result, 5)
    }
    
    func testStoreCommentsError() throws {
        
        // Given
        let recordedError = Variable<Error?>(nil)
        let comments: Comments = try JSON(named: "comments")
        let config = Realm.Configuration.init(fileURL: URL(fileURLWithPath: "/invalidPath"))
        let storage: StorageType = RealmPersistantStorage(configuration: config)
        
        // When
        storage.storeComments(onError: { recordedError.value = $0 }).onNext(comments)
        
        // Then
        let error = try! recordedError.asObservable().toBlocking(timeout: 1).first()!
        XCTAssertNotNil(error)
        
        guard let error1 = error else { return }
        
        if case RealmPersistantStorage.Error.realmFailedToInitiate(_) = error1 {
            // All good
        } else {
            XCTFail("Unknown error returned error: \(error1)")
        }
    }
}
