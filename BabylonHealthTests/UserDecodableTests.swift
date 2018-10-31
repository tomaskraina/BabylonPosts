//
//  UserDecodableTests.swift
//  BabylonHealthTests
//
//  Created by Tom Kraina on 30/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import XCTest
@testable import BabylonHealth

class UserDecodableTests: XCTestCase {

    func testDecodeNormalUser() throws {

        // Original URL: https://jsonplaceholder.typicode.com/users/1
        let json = """
            {
              "id": 1,
              "name": "Leanne Graham",
              "username": "Bret",
              "email": "Sincere@april.biz",
              "address": {
                "street": "Kulas Light",
                "suite": "Apt. 556",
                "city": "Gwenborough",
                "zipcode": "92998-3874",
                "geo": {
                  "lat": "-37.3159",
                  "lng": "81.1496"
                }
              },
              "phone": "1-770-736-8031 x56442",
              "website": "hildegard.org",
              "company": {
                "name": "Romaguera-Crona",
                "catchPhrase": "Multi-layered client-server neural-net",
                "bs": "harness real-time e-markets"
              }
            }
        """.data(using: .utf8)!

        let user = try JSONDecoder().decode(User.self, from: json)

        // Test just the basic info here
        // TODO: Add more tests once more properties will be in use
        XCTAssertEqual(user.id.rawValue, 1)
        XCTAssertEqual(user.name, "Leanne Graham")
        XCTAssertEqual(user.email, "Sincere@april.biz")
        XCTAssertEqual(user.address.street, "Kulas Light")
        XCTAssertEqual(user.company.name, "Romaguera-Crona")
    }
    
    func testDecodeNormalUsersResponse() throws {
        let response: Users = try JSON(named: "users")
        XCTAssertFalse(response.isEmpty)
    }
    
    func testPerformanceDecodePostsResponse() {
        self.measure {
            _ = try? JSON(named: "users") as Users
        }
    }

}
