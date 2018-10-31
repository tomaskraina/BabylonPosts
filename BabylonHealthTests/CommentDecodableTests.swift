//
//  CommentDecodableTests.swift
//  BabylonHealthTests
//
//  Created by Tom Kraina on 30/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import XCTest
@testable import BabylonHealth

class CommentDecodableTests: XCTestCase {

    func testDecodeNormalComment() throws {
        
        // Original URL: https://jsonplaceholder.typicode.com/comments/1
        // NOTE: When using multiline string literals, a new-line '\n' must be escaped with additional '\'.
        let json = """
            {
              "postId": 1,
              "id": 1,
              "name": "id labore ex et quam laborum",
              "email": "Eliseo@gardner.biz",
              "body": "laudantium enim quasi est quidem magnam voluptate ipsam eos\\ntempora quo necessitatibus\\ndolor quam autem quasi\\nreiciendis et nam sapiente accusantium"
            }
        """.data(using: .utf8)!
        
        let comment = try JSONDecoder().decode(Comment.self, from: json)
        
        XCTAssertEqual(comment.id.rawValue, 1)
        XCTAssertEqual(comment.postID.rawValue, 1)
        XCTAssertEqual(comment.name, "id labore ex et quam laborum")
        XCTAssertEqual(comment.email, "Eliseo@gardner.biz")
        XCTAssertEqual(comment.body, "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium")
    }
    
    func testDecodeNormalCommentsResponse() throws {
        let response: Comments = try JSON(named: "comments")
        XCTAssertFalse(response.isEmpty)
    }
    
    func testPerformanceDecodePostsResponse() {
        self.measure {
            _ = try? JSON(named: "comments") as Comments
        }
    }
}
