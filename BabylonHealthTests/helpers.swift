//
//  helpers.swift
//  BabylonHealthTests
//
//  Created by Tom Kraina on 31/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation

private class _BabylonHealthTests: NSObject {}

let BabylonHealthTestsBundle = Bundle(for: _BabylonHealthTests.self)

func JSON<T: Decodable>(named name: String, bundle: Bundle = BabylonHealthTestsBundle) throws -> T {
    
    let url = bundle.url(forResource: name, withExtension: "json")!
    let data = try Data(contentsOf: url)
    do {
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        print(error)
        throw error
    }
}
