//
//  NetworkingType.swift
//  BabylonPosts
//
//  Created by Tom Kraina on 16/12/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation
import RxSwift

protocol NetworkingType {
    @discardableResult
    func request<T: Decodable>(endpoint: Endpoint) -> Single<T>
    var isLoading: Observable<Bool> { get }
}
