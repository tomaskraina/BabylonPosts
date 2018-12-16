//
//  ApiClientIntegrationTests.swift
//  BabylonHealthTests
//
//  Created by Tom Kraina on 31/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import XCTest
@testable import BabylonPosts
import RxSwift
import RxBlocking
import Alamofire

private func createApiClient() -> ApiClientType {
    // Use ephemeral config in order to avoid url cache
    let sessionManager = SessionManager(configuration: URLSessionConfiguration.ephemeral)
    let networking = Networking(manager: sessionManager)
    let apiClient = JSONPlaceholderApiClient(networking: networking)
    return apiClient
}

class ApiClientIntegrationTests: XCTestCase {
    
    func testRequestPostList() throws {
        let apiClient = createApiClient()
        let result = try apiClient.requestPostList().toBlocking(timeout: 100).single()
        XCTAssertFalse(result.isEmpty)
    }
    
    func testRequestUserList() throws {
        let apiClient = createApiClient()
        let result = try apiClient.requestUserList().toBlocking(timeout: 100).single()
        XCTAssertFalse(result.isEmpty)
    }
    
    func testRequestUserDetail() throws {
        let apiClient = createApiClient()
        let id = Identifier<User>(integerLiteral: 1)
        let result = try apiClient.requestUser(id: id).toBlocking(timeout: 100).single()
        XCTAssertEqual(result.id, id)
    }

    func testRequestUserDetailNotFound() throws {
        let apiClient = createApiClient()
        let id = Identifier<User>(integerLiteral: -1) // Assume this is user id does not exist
        XCTAssertThrowsError(_ = try apiClient.requestUser(id: id).toBlocking(timeout: 100).single(), "Expected ApiClientError.itemNotFound") { error in
            guard case ApiClientError.itemNotFound = error else {
                XCTFail("Expected ApiClientError.itemNotFound, found: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func testRequestCommentList() throws {
        let apiClient = createApiClient()
        let id = Identifier<Post>(integerLiteral: 1)
        let result = try apiClient.requestComments(postId: id) .toBlocking(timeout: 100).single()
        XCTAssertEqual(result.first?.postID, id)
    }

}
