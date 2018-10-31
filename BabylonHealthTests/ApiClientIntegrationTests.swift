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

class ApiClientIntegrationTests: XCTestCase {

    func testRequestPostList() throws {
        
        // Use ephemeral config in order to avoid url cache
        let sessionManager = SessionManager(configuration: URLSessionConfiguration.ephemeral)
        let networking = Networking.init(manager: sessionManager)
        let apiClient = ApiClient.init(networking: networking)
        
        let result = try apiClient.requestPostList().toBlocking(timeout: 100).single()
        XCTAssertFalse(result.isEmpty)
    }

}
