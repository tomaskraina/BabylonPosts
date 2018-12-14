//
//  DecodableResult.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 14/12/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation

/// Enum that wraps any type conforming to Decodable.
/// Useful for handling elements and errors in array that can't be decoded.
///
/// Inspired by https://stackoverflow.com/questions/46344963/
///
/// - success: Type successfully decoded 
/// - failure: Type failed to decode with associated error
enum DecodableResult<T: Decodable>: Decodable {
    case success(T)
    case failure(Error)
    
    init(from decoder: Decoder) throws {
        do {
            let decoded = try T(from: decoder)
            self = .success(decoded)
        } catch let error {
            self = .failure(error)
        }
    }
}

extension DecodableResult {
    var value: T? {
        switch self {
        case .failure:
            return nil
        case .success(let value):
            return value
        }
    }
    
    var error: Error? {
        switch self {
        case .failure(let error):
            return error
        case .success:
            return nil
        }
    }
}
