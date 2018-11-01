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
    
}

protocol PostListViewModelOutputs {
    
}

protocol PostListViewModelling {
    var inputs: PostListViewModelInputs { get }
    var outputs: PostListViewModelOutputs { get }
}

// MARK: - Implementation

class PostListViewModel: PostListViewModelInputs, PostListViewModelOutputs {
    
    typealias Dependencies = HasApiClient
    
    init(dependencies: Dependencies) {
        
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
