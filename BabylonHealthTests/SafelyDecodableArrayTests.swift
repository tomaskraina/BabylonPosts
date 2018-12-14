//
//  SafelyDecodableArrayTests.swift
//  BabylonHealthTests
//
//  Created by Tom Kraina on 14/12/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import XCTest
@testable import BabylonHealth


class SafelyDecodableArrayTests: XCTestCase {

    func testDecodeWithOneCorrectAndOneIncorrectElement() throws {
        
        struct Person: Codable {
            let name: String
        }
        
        // Given
        let json = """
            [
                {"name": "John"},
                {}
            ]
        """.data(using: .utf8)!
        
        //  When
        let decodedArray = try JSONDecoder().decode(SafelyDecodableArray<Person>.self, from: json)
        
        // Then
        XCTAssertEqual(decodedArray.count, 1)
        XCTAssertEqual(decodedArray.first?.name, "John")
        XCTAssertEqual(decodedArray.decodingErrors.count, 1)
        XCTAssertTrue(decodedArray.decodingErrors.first is DecodingError)
        XCTAssertEqual((decodedArray.decodingErrors.first as? DecodingError)?.isDecodingErrorKeyNotFound, true)
        XCTAssertEqual((decodedArray.decodingErrors.first as? DecodingError)?.decodingErrorKeyNotFoundCodingKey?.stringValue, "name")
    }

}

extension DecodingError {
    
    var decodingErrorKeyNotFoundCodingKey: CodingKey? {
        if case let DecodingError.keyNotFound(key, _) = self {
            return key
        } else {
            return nil
        }
    }
    
    var isDecodingErrorKeyNotFound: Bool {
        if case DecodingError.keyNotFound = self {
            return true
        } else {
            return false
        }
    }
}
