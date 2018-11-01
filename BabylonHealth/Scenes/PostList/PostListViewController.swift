//
//  PostListViewController.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 01/11/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import UIKit

protocol PostListViewControllerDelegate: AnyObject {
    func postList(viewController: PostListViewController, didSelect post: Post)
}

class PostListViewController: UITableViewController {

    // MARK: - Configuration
    
    var viewModel: PostListViewModelling!
    
    weak var delegate: PostListViewControllerDelegate?
    
    // MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
