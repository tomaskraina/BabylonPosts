//
//  MockApiClient.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 06/11/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation
import RxSwift

class MockApiClient: ApiClient {
    
    private let defaultDelay: TimeInterval = 2.0
    
    func requestPostList() -> Single<Posts> {
        
        return Single.create { handler in
            let jsonData = """
                [
                    {
                        "userId": 1,
                        "id": 1,
                        "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
                        "body": "quia et suscipit"
                    }
                ]
            """.data(using: .utf8)!
            
            let posts = try! JSONDecoder().decode(Posts.self, from: jsonData)
            handler(.success(posts))
            
            return Disposables.create()
        }.delay(defaultDelay, scheduler: MainScheduler.asyncInstance)
    }
    
    func requestUserList() -> Single<Users> {
        return Single.create { handler in
            let jsonData = """
                [
                    {
                        "id": 1,
                        "name": "Leanne Graham",
                        "username": "Bret",
                        "email": "Sincere@april.biz",
                        "address": {
                            "street": "Kulas Light",
                            "suite": "Apt. 556",
                            "city": "Gwenborough",
                            "zipcode": "92998-3874",
                            "geo": {
                                "lat": "-37.3159",
                                "lng": "81.1496"
                            }
                        },
                        "phone": "1-770-736-8031 x56442",
                        "website": "hildegard.org",
                        "company": {
                            "name": "Romaguera-Crona",
                            "catchPhrase": "Multi-layered client-server neural-net",
                            "bs": "harness real-time e-markets"
                        }
                    }
                ]
            """.data(using: .utf8)!
            
            let decoded = try! JSONDecoder().decode(Users.self, from: jsonData)
            handler(.success(decoded))
            
            return Disposables.create()
        }.delay(defaultDelay, scheduler: MainScheduler.asyncInstance)
    }
    
    func requestUser(id: Identifier<User>) -> Single<User> {
        return Single.create { observer in
            let jsonData = """
                [
                    {
                        "id": 1,
                        "name": "Leanne Graham",
                        "username": "Bret",
                        "email": "Sincere@april.biz",
                        "address": {
                            "street": "Kulas Light",
                            "suite": "Apt. 556",
                            "city": "Gwenborough",
                            "zipcode": "92998-3874",
                            "geo": {
                                "lat": "-37.3159",
                                "lng": "81.1496"
                            }
                        },
                        "phone": "1-770-736-8031 x56442",
                        "website": "hildegard.org",
                        "company": {
                            "name": "Romaguera-Crona",
                            "catchPhrase": "Multi-layered client-server neural-net",
                            "bs": "harness real-time e-markets"
                        }
                    }
                ]

            """.data(using: .utf8)!
            
            let decoded = try! JSONDecoder().decode(Users.self, from: jsonData)
            observer(.success(decoded.first!))
            
            return Disposables.create()
        }.delay(defaultDelay + 0.5, scheduler: MainScheduler.asyncInstance)
    }
    
    func requestComments(postId: Identifier<Post>) -> Single<Comments> {
        return Single.create { handler in
            let jsonData = """
                [
                    {
                        "postId": 1,
                        "id": 1,
                        "name": "id labore ex et quam laborum",
                        "email": "Eliseo@gardner.biz",
                        "body": "laudantium enim quasi est quidem magnam voluptate ipsam eos"
                    }
                ]
            """.data(using: .utf8)!
            
            let decoded = try! JSONDecoder().decode(Comments.self, from: jsonData)
            handler(.success(decoded))
            
            return Disposables.create()
            
        }.delay(defaultDelay + 0.5, scheduler: MainScheduler.asyncInstance)
    }
}
