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
        let title = "Something went wrong" // TODO: L10n
        let message = error.localizedDescription
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // TODO: L10n
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
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
            // TODO: L10n
            retry = UIAlertAction.Action("Retry", style: .default)
            retry?.rx.action = retryAction
        }
        
        return makeAlert(networkError: error, retryAction: retry)
    }
}
