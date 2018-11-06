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

// TODO: Refactor to its own file
extension UIFont {
    static var caption: UIFont {
        return UIFont.preferredFont(forTextStyle: .caption1)
    }
    
    static var value: UIFont {
        return UIFont.preferredFont(forTextStyle: .body)
    }
}


// TODO: Refactor to its own file
class CaptionValueLabelPair: UIView {
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loadingValueContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        captionLabel.font = .caption
        valueLabel.font = .value
        
        loadingValueContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 28).isActive = true
    }
}

class PostDetailViewController: UIViewController {

    // MARK: - Configuration
    
    var viewModel: PostDetailViewModelling!
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var authorName: CaptionValueLabelPair!
    @IBOutlet weak var postDescription: CaptionValueLabelPair!
    @IBOutlet weak var numberOfComments: CaptionValueLabelPair!
    
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
