//
//  PostDetailViewModel.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 01/11/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import Foundation

import RxSwift
import RxDataSources


// MARK: - Protocols

protocol PostDetailViewModelInputs {
    
}

protocol PostDetailViewModelOutputs {
    
}

protocol PostDetailViewModelling {
    var inputs: PostDetailViewModelInputs { get }
    var outputs: PostDetailViewModelOutputs { get }
}

// MARK: - Implementation

class PostDetailViewModel: PostDetailViewModelInputs, PostDetailViewModelOutputs {
    
    typealias Dependencies = AnyObject // TODO:
    
    init(dependencies: Dependencies) {
        
    }
    
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
