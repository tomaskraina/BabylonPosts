//
//  NetworkingError.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 30/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation

enum NetworkingError: LocalizedError {
    case network(Error, response: HTTPURLResponse?)
    case notFound(Error, response: HTTPURLResponse?)
    
    var errorDescription: String? {
        switch self {
        case .network(let error, _):
            return error.localizedDescription
            
        case .notFound:
            return "Requested item not found." // TODO: L10n
        }
    }
}

extension NetworkingError {
    
    enum HTTPStatusCode: Int {
        case notFound = 404
    }
    
    init(error: Error, httpUrlResponse: HTTPURLResponse?) {
        if httpUrlResponse?.statusCode == HTTPStatusCode.notFound.rawValue {
            self = .notFound(error, response: httpUrlResponse)
        } else {
            self = .network(error, response: httpUrlResponse)
        }
    }
}
