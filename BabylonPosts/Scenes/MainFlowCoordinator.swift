//
//  MainFlowCoordinator.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 01/11/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import UIKit

class MainFlowCoordinator {

    typealias Dependencies = HasDataProvider & HasUsersProvider & HasCommentsProvider
    
    let window: UIWindow

    let dependencies: Dependencies

    var navigationController: UINavigationController?

    init(window: UIWindow, dependencies: Dependencies) {
        self.window = window
        self.dependencies = dependencies
    }

    func loadRootViewController() {
        
        let viewController = StoryboardScene.PostList.initialScene.instantiate()
        
        let viewModel = PostListViewModel(dependencies: dependencies)
        viewController.viewModel = viewModel
        viewController.delegate = self
        
        navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func showDetail(post: Post) {
        
        let viewController = StoryboardScene.PostDetail.initialScene.instantiate()
        let viewModel = PostDetailViewModel(post: post, dependencies: dependencies)
        viewController.viewModel = viewModel
        
        navigationController?.pushViewController(viewController, animated: true)
    }

}

// MARK: - MainFlowCoordinator: PostListViewControllerDelegate
extension MainFlowCoordinator: PostListViewControllerDelegate {
    func postList(viewController: PostListViewController, didSelect post: Post) {
        showDetail(post: post)
    }
}
