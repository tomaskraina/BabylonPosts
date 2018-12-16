//
//  UIAlertController+makeAlert.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 02/11/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import UIKit

// MARK: - UIAlertController+makeAlertCocoaAction
extension UIAlertController {
    static func makeAlert(networkError error: Error, retryAction: UIAlertAction?) -> UIAlertController {
        let title = NSLocalizedString("error.title", comment: "Error")
        let message = error.localizedDescription
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("error.cancel", comment: "Error"), style: .cancel, handler: nil))
        
        if let retryAction = retryAction {
            alert.addAction(retryAction)
        }
        
        return alert
    }
}


// MARK: - UIAlertController+makeAlertCocoaAction
import Action
extension UIAlertController {
    static func makeAlert(networkError error: Error, retryAction: CocoaAction?) -> UIAlertController {
        var retry: UIAlertAction?
        if let retryAction = retryAction {
            retry = UIAlertAction.Action(NSLocalizedString("error.retry", comment: "Error"), style: .default)
            retry?.rx.action = retryAction
        }
        
        return makeAlert(networkError: error, retryAction: retry)
    }
}
