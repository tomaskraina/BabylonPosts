//
//  CaptionValueLabelPairView.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 10/12/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import UIKit

@IBDesignable
class CaptionValueLabelPairView: UIView {
    
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loadingValueContainer: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setupNib()
        
        // Set up after view hierarchy is load from nib
        captionLabel.font = .caption
        valueLabel.font = .value
    }
}
