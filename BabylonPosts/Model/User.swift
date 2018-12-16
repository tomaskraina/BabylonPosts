//
//  User.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 30/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation

typealias UsersResponse = SafelyDecodableArray<User>

typealias Users = [User]

struct User: Codable, Identifiable, Equatable, Hashable {
    let id: Identifier<User>
    let name, username, email: String
    
    // Uncomment if more info about the user is needed
    // If uncommented, you need to update User+
//    let address: Address
//    let phone, website: String
//    let company: Company
    
}

struct Address: Codable, Equatable, Hashable {
    let street, suite, city, zipcode: String
    let geo: Geo
}

struct Geo: Codable, Equatable, Hashable {
    let lat, lng: String
}

struct Company: Codable, Equatable, Hashable {
    let name, catchPhrase, bs: String
}
