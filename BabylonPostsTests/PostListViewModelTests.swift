//
//  PostListViewModelTests.swift
//  BabylonPostsTests
//
//  Created by Tom Kraina on 16/12/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import XCTest
@testable import BabylonPosts
import RxSwift
import RxBlocking
import RxTest
import RxDataSources


class PostListViewModelTests: XCTestCase {

    var disposeBag: DisposeBag! = DisposeBag()

    // TODO: Test reloadAction
    // TODO: Test isRefreshing
    
    func testTableContentDriver() throws {
     
        // Given
        let scheduler = TestScheduler(initialClock: 0)
        let dataSourceObserver = scheduler.createObserver(Array<Posts>.self)
        let postsInput = PublishSubject<[Post]>()
        let mock = MockDataProvider.init(
            onDeleteAllData: nil, onRequestUserId: nil, userObservable: .empty(), onRequestPosts: nil, postsObservable: postsInput.asObservable(), onRequestComments: nil, commentCountObservable: .empty())
        let viewModel = PostListViewModel(dependencies: mock)
        viewModel.tableContents
            .map{ $0.map({ $0.items }) }
            .drive(dataSourceObserver)
            .disposed(by: disposeBag)
        
        let value1: [Post] = []
        let value2: [Post] = [
            Post(id: 1, userID: 1, title: "", body: ""),
            Post(id: 2, userID: 2, title: "", body: ""),
        ]
        
        // When
        scheduler.scheduleAt(0) {
            postsInput.onNext(value1)
        }
        scheduler.scheduleAt(10) {
            postsInput.onNext(value2)
        }
        scheduler.start()
        
        // Then
        // TODO: Compare Array<SectionModel<Int, Post>> instead but it's not Equatable?
        let expectectation = [
            next(0, [value1]),
            next(10, [value2]),
        ]
        
        XCTAssertEqual(expectectation, dataSourceObserver.events)
    }

}
