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
        
        let requestingUserList = ActivityTracker()
        
        apiClient.requestUser(id: post.userID)
            .debug("requestUserList", trimOutput: true)
            .trackActivity(requestingUserList)
            .map { [$0] }
            .subscribe(storage.storeUsers(onError: nil))
            .disposed(by: disposeBag)
        
        let requestingComments = ActivityTracker()
        
        apiClient.requestComments(postId: post.id)
            .debug("requestComments", trimOutput: true)
            .trackActivity(requestingComments)
            .subscribe(storage.storeComments(onError: nil))
            .disposed(by: disposeBag)
        
        user = storage.user(id: post.userID)
            .debug("storage.user", trimOutput: true)
        
        isLoadingAuthorName = Observable
            .merge(requestingUserList.asObservable(), user.map { _ in false } )
            .asDriver(onErrorJustReturn: false)
        
        commentCount = storage.commentCount(for: post.id)
            .debug("storage.commentCount", trimOutput: true)
        
        isLoadingNumberOfComments = Observable
            .merge(requestingComments.asObservable(), commentCount.map { $0 == 0 } )
            .asDriver(onErrorJustReturn: false)
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
        let usernameDriver = user.map { $0.username }
            .startWith("")
            .asDriver(onErrorJustReturn: "N/A")  // TODO: L10n
        
        return Driver.combineLatest(usernameDriver, isLoadingAuthorName, resultSelector: { (username, isLoading) in
            return isLoading || !username.isEmpty ? username : "N/A" // TODO: L10n
        })
    }
    
    var postDescription: Driver<String> {
        return post.asObservable().map { $0.body }
            .startWith("")
            .asDriver(onErrorJustReturn: "N/A")  // TODO: L10n
    }
    
    var numberOfComment: Driver<String> {
        
        let commentCountDriver = commentCount
            .map(String.init)
            .startWith("")
            .asDriver(onErrorJustReturn: "N/A")  // TODO: L10n
        
        return Driver.combineLatest(commentCountDriver, isLoadingNumberOfComments, resultSelector: { (count, isLoading) in
            if count != "0" {
                return count
            } else if isLoading {
                return ""
            } else {
                return "N/A"
            }
        })
    }
    
    let isLoadingAuthorName: Driver<Bool>
    
    var isLoadingPostDescription: Driver<Bool> {
        return Driver.just(false)
    }
    
    let isLoadingNumberOfComments: Driver<Bool>
    
    
    // MARK: - Privates
    
    private let apiClient: ApiClient
    
    private let storage: PersistentStorage
    
    private let post: Variable<Post>
    
    private let user: Observable<User>
    
    private let commentCount: Observable<Int>
    
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
