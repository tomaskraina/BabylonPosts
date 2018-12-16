//
//  Dependencies.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 01/11/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation

// Inspired by: http://merowing.info/2017/04/using-protocol-compositon-for-dependency-injection/

protocol HasApiClient {
    var apiClient: ApiClientType { get }
}

protocol HasPersistenceStorage {
    var storage: StorageType { get }
}

protocol HasDataProvider {
    var dataProvider: DataProviderType { get }
}

protocol HasPostsProvider {
    var posts: PostsProviderType { get }
}

protocol HasUsersProvider {
    var users: UsersProviderType { get }
}

protocol HasCommentsProvider {
    var comments: CommentsProviderType { get }
}
