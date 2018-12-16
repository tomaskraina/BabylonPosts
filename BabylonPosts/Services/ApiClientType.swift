//
//  ApiClientType.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 30/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - Protocols

protocol ApiClientType {
    func requestPostList() -> Single<Posts>
    func requestUserList() -> Single<Users>
    func requestUser(id: Identifier<User>) -> Single<User>
    func requestComments(postId: Identifier<Post>) -> Single<Comments>
}

enum ApiClientError: Error {
    case itemNotFound
    case other(underlyingError: Error)
}
