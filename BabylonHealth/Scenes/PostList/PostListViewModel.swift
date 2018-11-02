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


// MARK: - Protocols

protocol PostListViewModelInputs {
    func reload()
}

protocol PostListViewModelOutputs {
    // TODO: Driver
    var tableContents: Observable<[SectionModel<Int, Post>]> { get }
    
    // TODO: Driver
    var onError: PublishSubject<Error> { get }
    
    // TODO: Driver?
    var isRefreshing: Observable<Bool> { get }
}

protocol PostListViewModelling: AnyObject {
    var inputs: PostListViewModelInputs { get }
    var outputs: PostListViewModelOutputs { get }
}

// MARK: - Implementation

class PostListViewModel: PostListViewModelInputs, PostListViewModelOutputs {
    
    typealias Dependencies = HasApiClient
    
    init(dependencies: Dependencies) {
        apiClient = dependencies.apiClient
    }
    
    func reload() {
        // Don't fire multiple requests at once, either cancel previous or ignore the subsequent
        guard isLoading.value == false else { return }
        
        isLoading.value = true
        // TODO: Driver?
        apiClient.requestPostList()
            .do(onError: { [weak self] (error) in
                print(error)
                self?.onError.onNext(error)
                }, onDispose: { [weak self] in
                    self?.isLoading.value = false
            })
            .bind(to: posts)
            .disposed(by: disposeBag)
    }

    
    var tableContents: Observable<[SectionModel<Int, Post>]> {
        return posts.asObservable().map() {
            [SectionModel(model: 0, items: $0)]
        }
    }
    
    let onError = PublishSubject<Error>()
    
    var isRefreshing: Observable<Bool> {
        return isLoading.asObservable()
            .distinctUntilChanged()
        
        // TODO: delay deliver of false
    }

    // MARK: - Private
    
    private let disposeBag = DisposeBag()
    
    private let posts = Variable<Posts>([])
    
    private let apiClient: ApiClient
    
    private let isLoading = Variable<Bool>(false)
    
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
