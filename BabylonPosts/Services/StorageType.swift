//
//  StorageType.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 16/12/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation
import RxSwift

protocol StorageType {
    func posts() -> Observable<Posts>
    func storePosts(onError: ((LocalizedError) -> Void)?) -> AnyObserver<Posts>
    
    func user(id: Identifier<User>) -> Observable<User>
    func storeUsers(onError: ((LocalizedError) -> Void)?) -> RxSwift.AnyObserver<Users>
    
    func comments(for postId: Identifier<Post>) -> Observable<Comments>
    func commentCount(for postId: Identifier<Post>) -> Observable<Int>
    func storeComments(onError: ((LocalizedError) -> Void)?) -> RxSwift.AnyObserver<Comments>
    
    func deleteAllData(onError: ((LocalizedError) -> Void)?)
}
