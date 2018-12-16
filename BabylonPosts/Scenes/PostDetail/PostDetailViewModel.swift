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
import Action


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

protocol PostDetailViewModelType {
    var inputs: PostDetailViewModelInputs { get }
    var outputs: PostDetailViewModelOutputs { get }
}

// MARK: - Implementation

class PostDetailViewModel: PostDetailViewModelInputs, PostDetailViewModelOutputs {
    
    typealias Dependencies = HasUsersProvider & HasCommentsProvider
    
    init(post: Post, dependencies: Dependencies) {
        let usersProvider = dependencies.users
        let commentsProvider = dependencies.comments
        
        self.post = Variable<Post>(post)
        
        requestUserAction = Action<Identifier<User>, Void> { [usersProvider] (userId: Identifier<User>) in
            usersProvider.requestUser(id: userId)
                .debug("requestUserId: \(userId.rawValue)", trimOutput: true)
                .andThen(Observable.empty())
        }
        
        requestCommentsAction = Action<Identifier<Post>, Void> { [commentsProvider] (postId) in
            commentsProvider.requestComments(postId: postId)
                .debug("requestComments postId: \(postId.rawValue)", trimOutput: true)
                .andThen(Observable.empty())
        }
        
        user = usersProvider.user(id: post.userID)
        
        isLoadingAuthorName = Observable
            .merge(requestUserAction.executing, user.map { _ in false } )
            .asDriver(onErrorJustReturn: false)
        
        commentCount = commentsProvider.commentCount(postId: post.id)
            .debug("commentCount", trimOutput: true)
        
        isLoadingNumberOfComments = Observable
            .merge(requestCommentsAction.executing, commentCount.map { $0 == 0 } )
            .asDriver(onErrorJustReturn: false)
        
        // Fire requests
        requestUserAction.execute(post.userID)
        requestCommentsAction.execute(post.id)
    }
    
    var authorNameCaption: Driver<String> {
        return Driver.just(NSLocalizedString("detail.author.caption", comment: "Detail"))
    }
    
    var postDescriptionCaption: Driver<String> {
        return Driver.just(NSLocalizedString("detail.body.caption", comment: "Detail"))
    }
    
    var numberOfCommentsCaption: Driver<String> {
        return Driver.just(NSLocalizedString("detail.commentCount.caption", comment: "Detail"))
    }
    
    var title: Driver<String> {
        return Driver.just(NSLocalizedString("detail.title", comment: "Detail"))
    }
    
    var authorName: Driver<String> {
        let usernameDriver = user.map { $0.username }
            .startWith("")
            .asDriver(onErrorJustReturn: "")
        
        return Driver.combineLatest(usernameDriver, isLoadingAuthorName, resultSelector: { (username, isLoading) in
            return isLoading || !username.isEmpty ? username : NSLocalizedString("detail.author.value.missing", comment: "Detail")
        })
    }
    
    var postDescription: Driver<String> {
        return post.asObservable().map { $0.body }
            .startWith("")
            .asDriver(onErrorJustReturn: NSLocalizedString("detail.body.value.missing", comment: "Detail"))
    }
    
    var numberOfComment: Driver<String> {
        
        let commentCountDriver = commentCount
            .map(String.init)
            .startWith("")
            .asDriver(onErrorJustReturn: "")
        
        return Driver.combineLatest(commentCountDriver, isLoadingNumberOfComments, resultSelector: { (count, isLoading) in
            if count != "0" {
                return count
            } else if isLoading {
                return ""
            } else {
                return NSLocalizedString("detail.commentCount.value.missing", comment: "Detail")
            }
        })
    }
    
    let isLoadingAuthorName: Driver<Bool>
    
    var isLoadingPostDescription: Driver<Bool> {
        return Driver.just(false)
    }
    
    let isLoadingNumberOfComments: Driver<Bool>
    
    
    // MARK: - Privates
    
    private let requestUserAction: Action<Identifier<User>, Void>
    
    private let requestCommentsAction: Action<Identifier<Post>, Void>
    
    private let post: Variable<Post>
    
    private let user: Observable<User>
    
    private let commentCount: Observable<Int>
}

// MARK: - PostListViewModel+PostDetailViewModelType
extension PostDetailViewModel: PostDetailViewModelType {
    var inputs: PostDetailViewModelInputs {
        return self
    }
    
    var outputs: PostDetailViewModelOutputs {
        return self
    }
}
