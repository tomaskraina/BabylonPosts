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
    
    typealias Dependencies = HasApiClient & HasPersistenceStorage
    
    init(post: Post, dependencies: Dependencies) {
        self.apiClient = dependencies.apiClient
        self.storage = dependencies.storage
        
        self.post = Variable<Post>(post)
        
        apiClient.requestUserList()
            .debug("requestUserList", trimOutput: true)
            .subscribe(storage.storeUsers(onError: nil))
            .disposed(by: disposeBag)
        
        apiClient.requestComments(postId: post.id)
            .debug("requestComments", trimOutput: true)
            .subscribe(storage.storeComments(onError: nil))
            .disposed(by: disposeBag)
        
        user = storage.user(id: post.userID)
            .debug("storage.user", trimOutput: true)
        
        commentCount = storage.commentCount(for: post.id)
            .debug("storage.commentCount", trimOutput: true)
    }
    
    var authorNameCaption: Driver<String> {
        return Driver.just("Author") // TODO: L10n
    }
    
    var postDescriptionCaption: Driver<String> {
        return Driver.just("Body") // TODO: L10n
    }
    
    var numberOfCommentsCaption: Driver<String> {
        return Driver.just("Number of comments") // TODO: L10n
    }
    
    var title: Driver<String> {
        return Driver.just("Post detail") // TODO: L10n
    }
    
    var authorName: Driver<String> {
        return user.map { $0.username }
            .startWith("")
            .asDriver(onErrorJustReturn: "N/A")
    }
    
    var postDescription: Driver<String> {
        return post.asObservable().map { $0.body }
            .startWith("")
            .asDriver(onErrorJustReturn: "N/A")
    }
    
    var numberOfComment: Driver<String> {
        return commentCount
            .map(String.init)
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
    
    private let apiClient: ApiClient
    
    private let storage: PersistentStorage
    
    private let post: Variable<Post>
    
    private let user: Observable<User>
    
    private let commentCount: Observable<Int>
    
    private let isLoadingUserVariable: Variable<Bool> = .init(false)
    
    private let isLoadingCommentsVariable: Variable<Bool> = .init(false)
    
    private let disposeBag = DisposeBag()
    
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
