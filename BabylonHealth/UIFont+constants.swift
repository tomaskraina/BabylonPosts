//
//  UIFont+constants.swift
//  BabylonHealth
//
//  Created by Tom Kraina on 10/12/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import UIKit

extension UIFont {
    static var caption: UIFont {
        return UIFont.preferredFont(forTextStyle: .caption1)
    }
    
    static var value: UIFont {
        return UIFont.preferredFont(forTextStyle: .body)
    }
}
