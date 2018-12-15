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

import RealmSwift
import RxRealm
import Action

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

protocol PostListViewModelling: AnyObject {
    var inputs: PostListViewModelInputs { get }
    var outputs: PostListViewModelOutputs { get }
}

// MARK: - Implementation

class PostListViewModel: PostListViewModelInputs, PostListViewModelOutputs {
    
    typealias Dependencies = HasApiClient & HasPersistenceStorage
    
    init(dependencies: Dependencies) {
        apiClient = dependencies.apiClient
        storage = dependencies.storage

        reloadAction = Action<Void, Void> { [apiClient, storage] _ -> Observable<Void> in
            Observable.create({ (observer) -> Disposable in
                return apiClient.requestPostList()
                    .asObservable()
                    .do(onError: { observer.onError($0) }, onCompleted: { observer.onCompleted() })
                    .subscribe(storage.storePosts { observer.onError($0) })
            })
        }
        
        deleteAction = Action<Void, Void> { [storage] in
            Observable.create({ (observer) in
                storage.deleteAllData {
                    observer.onError($0)
                }
                observer.onCompleted()
                return Disposables.create()
            })
        }
        
        tableContents = storage.posts()
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
    
    private let apiClient: ApiClient
    
    private let storage: PersistentStorage
}

// MARK: - PostListViewModel+PostListViewModelling
extension PostListViewModel: PostListViewModelling {
    var inputs: PostListViewModelInputs {
        return self
    }
    
    var outputs: PostListViewModelOutputs {
        return self
    }
}
