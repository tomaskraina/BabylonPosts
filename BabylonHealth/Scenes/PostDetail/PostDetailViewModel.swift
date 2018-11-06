//
//  PostDetailViewModel.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 01/11/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import RxDataSources


// MARK: - Protocols

protocol PostDetailViewModelInputs {}

protocol PostDetailViewModelOutputs {
    var title: Driver<String> { get }
    var isLoadingAuthorName: Driver<Bool> { get }
    var authorName: Driver<String> { get }
    var authorNameCaption: Driver<String> { get }
    
    var isLoadingPostDescription: Driver<Bool> { get }
    var postDescription: Driver<String> { get }
    var postDescriptionCaption: Driver<String> { get }
    
    var isLoadingNumberOfComments: Driver<Bool> { get }
    var numberOfComment: Driver<String> { get }
    var numberOfCommentsCaption: Driver<String> { get }
}

protocol PostDetailViewModelling {
    var inputs: PostDetailViewModelInputs { get }
    var outputs: PostDetailViewModelOutputs { get }
}

// MARK: - Implementation

class PostDetailViewModel: PostDetailViewModelInputs, PostDetailViewModelOutputs {
    
    var authorNameCaption: Driver<String> {
        return Driver.just("Author") // TODO: L10n
    }
    
    var postDescriptionCaption: Driver<String> {
        return Driver.just("Body") // TODO: L10n
    }
    
    var numberOfCommentsCaption: Driver<String> {
        return Driver.just("Number of comments") // TODO: L10n
    }
    
    
    typealias Dependencies = HasApiClient
    
    init(post: Post, dependencies: Dependencies) {
        self.apiClient = dependencies.apiClient
        self.post = Variable<Post>(post)
        
        // TODO: Do this differently as apiClient is captured
        self.user = self.post.asObservable().flatMap({ [apiClient] (post) -> Observable<User> in
            return apiClient.requestUserList()
                .debug("users request", trimOutput: true)
                .map({ $0.first(where: { $0.id == post.userID }) })
                .flatMap({ value -> Observable<User> in
                    if let value = value {
                        return Observable.just(value)
                    } else {
                        return Observable.empty()
                    }
                }).debug("user", trimOutput: true)
        })
        
        self.comments = self.post.asObservable()
            .flatMap({ [apiClient] (post) -> Observable<Comments> in
            return apiClient.requestComments(postId: post.id)
            }).debug("comments", trimOutput: true)
    }
    
    var title: Driver<String> {
        return Driver.just("Post detail") // TODO: L10n
    }
    
    var authorName: Driver<String> {
        return user.map({ $0.username })
            .do(onNext: { [weak self] (_) in
                self?.isLoadingUserVariable.value = false
                }, onSubscribe: { [weak self] in
                    self?.isLoadingUserVariable.value = true
            }).startWith("")
            .asDriver(onErrorJustReturn: "N/A")
    }
    
    var postDescription: Driver<String> {
        return post.asObservable().map({ $0.body })
            .startWith("")
            .asDriver(onErrorJustReturn: "N/A")
    }
    
    var numberOfComment: Driver<String> {
        return comments
            .map({ $0.count })
            .map(String.init)
            .do(onNext: { [weak self] (_) in
                self?.isLoadingCommentsVariable.value = false
                }, onSubscribe: { [weak self] in
                    self?.isLoadingCommentsVariable.value = true
            })
            .startWith("")
            .asDriver(onErrorJustReturn: "N/A")
    }
    
    var isLoadingAuthorName: Driver<Bool> {
        return isLoadingUserVariable.asDriver()
    }
    
    var isLoadingPostDescription: Driver<Bool> {
        return Driver.just(false)
    }
    
    var isLoadingNumberOfComments: Driver<Bool> {
        return isLoadingCommentsVariable.asDriver()
    }
    
    
    // MARK: - Privates
    
    private let post: Variable<Post>
    
    private let apiClient: ApiClient
    
    private let user: Observable<User>
    
    private let comments: Observable<Comments>
    
    private let isLoadingUserVariable: Variable<Bool> = .init(false)
    
    private let isLoadingCommentsVariable: Variable<Bool> = .init(false)
    
}

// MARK: - PostListViewModel+PostDetailViewModelling
extension PostDetailViewModel: PostDetailViewModelling {
    var inputs: PostDetailViewModelInputs {
        return self
    }
    
    var outputs: PostDetailViewModelOutputs {
        return self
    }
}
