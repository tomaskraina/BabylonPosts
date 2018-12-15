//
//  PostListViewController.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 01/11/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Action

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

        tableView.refreshControl = makeRefreshControl()
        tableView.register(PostTableViewCell.nib()!, forCellReuseIdentifier: PostTableViewCell.nibName())
        setupBinding()
        
        viewModel.inputs.reloadAction.execute(())
        
        let deleteItem = UIBarButtonItem(barButtonSystemItem: .trash, target: nil, action: nil)
        navigationItem.rightBarButtonItem = deleteItem
        deleteItem.rx.tap.subscribe(onNext: { [weak viewModel] _ in
            viewModel?.inputs.deleteData()
        }).disposed(by: disposeBag)
    }

    // MARK: - IBAction
    
    @IBAction func pulledToRefresh() {
        viewModel.inputs.reloadAction.execute(())

    }
    
    // MARK: - Helpers
    
    private let disposeBag = DisposeBag()

    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<Int, Post>> {
        return RxTableViewSectionedReloadDataSource<SectionModel<Int, Post>>(
            configureCell: { (dataSource, tableView, indexPath, item) in
                let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.nibName(), for: indexPath)
                
                if let postCell = cell as? PostTableViewCell {
                    let viewModel = PostTableViewCellModel(post: item)
                    postCell.configure(viewModel: viewModel)
                }
                
                return cell
        })
    }
    
    private func setupBinding() {
        guard isViewLoaded else { return }
        
        viewModel?.outputs.tableContents
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Post.self)
            .subscribe(onNext: { [unowned self] in
                self.delegate?.postList(viewController: self, didSelect: $0) }
            ).disposed(by: disposeBag)
        
        viewModel?.outputs.onError
            .map({ [weak viewModel] error in
            UIAlertController.makeAlert(networkError: error, retryHandler: {
                viewModel?.inputs.reloadAction.execute(())
            })
        }).drive(onNext: { [weak self] (alert) in
            self?.present(alert, animated: true)
        }).disposed(by: disposeBag)
        
        viewModel?.outputs.isRefreshing
            .do(onNext: { [tableView] (newValue) in
                // When spinner is triggered programmatically right after app launch
                // we have to scroll the table view in order to make it visible
                // TODO: Consider using LoadingViewControllers instead as described here https://talk.objc.io/episodes/S01E3-loading-view-controllers
                guard newValue else { return }
                guard let tableView = tableView else { return }
                guard !tableView.refreshControl!.isRefreshing else { return }
                tableView.setContentOffset(CGPoint(x: 0, y: -tableView.refreshControl!.frame.size.height), animated: true)
            })
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.inputs.reloadAction.inputs)
            .disposed(by: disposeBag)
    }
    
    private func makeRefreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        // No need to set up target-action here as rx binding is used instead
        return refreshControl
    }
}
