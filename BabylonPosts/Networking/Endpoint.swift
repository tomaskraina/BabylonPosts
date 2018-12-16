//
//  Endpoint.swift
//  BabylonPosts
//
//  Created by Tom Kraina on 16/12/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation
import Alamofire

// Inspired by: http://chris.eidhof.nl/posts/typesafe-url-routes-in-swift.html

// MARK: - Protocols

public protocol Path {
    var path : String { get }
}

public protocol Endpoint: Path, URLConvertible {
    var baseURL: URL { get }
    var method: Alamofire.HTTPMethod { get }
    var parameters: [String: Any]? { get }
}

// MARK: - Endpoint + default implementation
extension Endpoint {
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    func asURL() throws -> URL {
        guard let url = URL(string: path, relativeTo: baseURL) else { throw AFError.invalidURL(url: self) }
        return url
    }
}
