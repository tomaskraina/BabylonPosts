//
//  PostListViewModel.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 01/11/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import RxCocoa
import Action

// TODO: Support pagination instead of requesting and displaying all posts at once

// MARK: - Protocols

protocol PostListViewModelInputs {
    var reloadAction: Action<Void, Void> { get }
    var deleteAction: Action<Void, Void> { get }
}

protocol PostListViewModelOutputs {
    var tableContents: Driver<[SectionModel<Int, Post>]> { get }
    
    /// Error stream -> show error in UIAlertController
    var onError: Driver<Error> { get }
    
    var isRefreshing: Driver<Bool> { get }
}

protocol PostListViewModelType: AnyObject {
    var inputs: PostListViewModelInputs { get }
    var outputs: PostListViewModelOutputs { get }
}

// MARK: - Implementation

class PostListViewModel: PostListViewModelInputs, PostListViewModelOutputs {
    
    typealias Dependencies = HasDataProvider
    
    init(dependencies: Dependencies) {
        dataProvider = dependencies.dataProvider

        reloadAction = Action<Void, Void> { [dataProvider] in
            dataProvider.posts.requestPosts()
                .andThen(Observable.empty())
        }
        
        deleteAction = Action<Void, Void> { [dataProvider] in
            dataProvider.deleteAllData()
                .andThen(Observable.empty())
        }
        
        tableContents = dataProvider.posts.allPosts()
            .asDriver(onErrorJustReturn: [])
            .map { [SectionModel(model: 0, items: $0)] }
    }
    
    // MARK: Inputs
    
    let reloadAction: Action<Void, Void>
    
    let deleteAction: Action<Void, Void>
    
    // MARK: Outputs
    
    let tableContents: Driver<[SectionModel<Int, Post>]>
    
    var onError: Driver<Error> {
        return Observable.merge(reloadAction.errors, deleteAction.errors)
            .asDriver(onErrorJustReturn: .notEnabled)
            .map {
                if case let ActionError.underlyingError(error) = $0 {
                    return error
                } else {
                    return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
    }
    
    var isRefreshing: Driver<Bool> {
        return reloadAction.executing
            .asDriver(onErrorJustReturn: false)
            .flatMapLatest({ (value) in
                // Delay the delivery of false in order to make the UI work nicer
                if value {
                    return Driver.just(value)
                } else {
                    return Driver.just(value).delay(0.5)
                }
            })
    }

    // MARK: - Privates
    
    private let dataProvider: DataProviderType
}

// MARK: - PostListViewModel+PostListViewModelType
extension PostListViewModel: PostListViewModelType {
    var inputs: PostListViewModelInputs {
        return self
    }
    
    var outputs: PostListViewModelOutputs {
        return self
    }
}
