//
//  ApiClientIntegrationTests.swift
//  BabylonHealthTests
//
//  Created by Tom Kraina on 31/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import XCTest
@testable import BabylonHealth
import RxSwift
import RxBlocking
import Alamofire

private func createApiClient() -> ApiClient {
    // Use ephemeral config in order to avoid url cache
    let sessionManager = SessionManager(configuration: URLSessionConfiguration.ephemeral)
    let networking = Networking.init(manager: sessionManager)
    let apiClient = ApiClient.init(networking: networking)
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
    
    func testRequestCommentList() throws {
        let apiClient = createApiClient()
        let id = Identifier<Post>(integerLiteral: 1)
        let result = try apiClient.requestComments(postId: id) .toBlocking(timeout: 100).single()
        XCTAssertEqual(result.first?.postID, id)
    }

}
