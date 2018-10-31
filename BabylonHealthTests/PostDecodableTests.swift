//
//  PostDecodableTests.swift
//  BabylonHealthTests
//
//  Created by Tom Kraina on 30/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import XCTest
@testable import BabylonHealth

class PostDecodableTests: XCTestCase {

    func testDecodeNormalPost() throws {
        
        // Original URL: https://jsonplaceholder.typicode.com/posts/1
        // NOTE: When using multiline string literals, a new-line '\n' must be escaped with additional '\'.
        let json = """
            {
              "userId": 1,
              "id": 1,
              "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
              "body": "quia et suscipit\\nsuscipit recusandae consequuntur expedita et cum\\nreprehenderit molestiae ut ut quas totam\\nnostrum rerum est autem sunt rem eveniet architecto"
            }
        """.data(using: .utf8)!
        
        let post = try JSONDecoder().decode(Post.self, from: json)
        
        XCTAssertEqual(post.id.rawValue, 1)
        XCTAssertEqual(post.userID.rawValue, 1)
        XCTAssertEqual(post.title, "sunt aut facere repellat provident occaecati excepturi optio reprehenderit")
        XCTAssertEqual(post.body, "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto")
    }

    func testDecodeNormalPostsResponse() throws {
        let response: Posts = try JSON(named: "posts")
        XCTAssertFalse(response.isEmpty)
    }
    
    func testPerformanceDecodePostsResponse() {
        self.measure {
            _ = try? JSON(named: "posts") as Posts
        }
    }
}
