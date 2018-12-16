//
//  PostDetailViewController.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 01/11/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PostDetailViewController: UIViewController {

    // MARK: - Configuration
    
    var viewModel: PostDetailViewModelling!
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var authorName: CaptionValueLabelPairView!
    @IBOutlet weak var postDescription: CaptionValueLabelPairView!
    @IBOutlet weak var numberOfComments: CaptionValueLabelPairView!
    
    // MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBinding()
    }

    // MARK: - Helpers
    
    private var disposeBag = DisposeBag()
    
    private func setupBinding() {
        
        viewModel.outputs.title
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        // MARK: author
        
        viewModel!.outputs.authorNameCaption
            .drive(authorName.captionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoadingAuthorName
            .drive(authorName.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel!.outputs.authorName
            .drive(authorName.valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        // MARK: comments
        
        viewModel!.outputs.numberOfCommentsCaption
            .drive(numberOfComments.captionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoadingNumberOfComments
            .drive(numberOfComments.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel!.outputs.numberOfComment
            .drive(numberOfComments.valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        // MARK: post description
        
        viewModel!.outputs.postDescriptionCaption
            .drive(postDescription.captionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoadingPostDescription
            .drive(postDescription.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel!.outputs.postDescription
            .drive(postDescription.valueLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
