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
        
        viewModel.inputs.reloadInput.onNext(())
    }

    // MARK: - IBAction
    
    @IBAction func pulledToRefresh() {
        viewModel.inputs.reloadInput.onNext(())
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
                viewModel?.inputs.reloadInput.onNext(())
            })
        }).drive(onNext: { [weak self] (alert) in
            self?.present(alert, animated: true)
        }).disposed(by: disposeBag)
        
        viewModel?.outputs.isRefreshing
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.inputs.reloadInput)
            .disposed(by: disposeBag)
    }
    
    private func makeRefreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        // No need to set up target-action here as rx binding is used instead
        return refreshControl
    }
}
