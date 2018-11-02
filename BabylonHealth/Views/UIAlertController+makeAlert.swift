//
//  UIAlertController+makeAlert.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 02/11/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func makeAlert(networkError error: Error, retryHandler: (() -> Void)?) -> UIAlertController {
        let title = "Something went wrong" // TODO: L10n
        let message = error.localizedDescription
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
         // TODO: L10n
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let retryHandler = retryHandler {
            // TODO: L10n
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                retryHandler()
            }))
        }
        
        return alert
    }
}
