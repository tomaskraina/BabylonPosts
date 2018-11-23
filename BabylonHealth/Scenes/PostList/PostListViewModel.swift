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


// MARK: - Protocols

protocol PostListViewModelInputs {
    
    // TODO: Maybe using something like InputSubject<T> would suit better? https://github.com/RxSwiftCommunity/Action
    /// Trigger the data reload by calling `.onNext(())` method on this property
    var reloadInput: PublishSubject<Void> { get }
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
    
    typealias Dependencies = HasApiClient
    
    init(dependencies: Dependencies) {
        apiClient = dependencies.apiClient
        
        reloadInput.subscribe(onNext: { [unowned self] _ in
            self.reload()
        }).disposed(by: disposeBag)
    }
    
    // MARK: Inputs
    
    let reloadInput = PublishSubject<Void>()
    
    // MARK: Outputs
    
    var tableContents: Driver<[SectionModel<Int, Post>]> {
        return posts.asDriver().map() {
            [SectionModel(model: 0, items: $0)]
        }
    }
    
    var onError: Driver<Error> {
        return error
            .asDriver()
            // TODO: Find a better way how to unwrap the optional
            .filter({ $0 != nil })
            .map({ $0! })
    }
    
    var isRefreshing: Driver<Bool> {
        return isLoading.asDriver()
            // Delay the delivery of false in order to make the UI work nicer
            .flatMapLatest({ (value) in
            if value {
                return Driver.just(value)
            } else {
                return Driver.just(value).delay(1)
            }
        })
    }

    // MARK: - Privates
    
    private let disposeBag = DisposeBag()
    
    private let posts = Variable<Posts>([])
    
    private let apiClient: ApiClient
    
    private let isLoading = Variable<Bool>(false)
    
    private let error = Variable<Error?>(nil)
    
    func reload() {
        // Don't fire multiple requests at once
        guard isLoading.value == false else { return }
        
        isLoading.value = true
        
        apiClient.requestPostList()
            .do(onError: { [weak self] (error) in
                self?.error.value = error
                }, onDispose: { [weak self] in
                    self?.isLoading.value = false
            })
            .bind(to: posts)
            .disposed(by: disposeBag)
    }
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
