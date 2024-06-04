//
//  UIColor+ext.swift
//  Strivvy
//
//  Created by Gustavo Munhoz Correa on 03/06/24.
//

import UIKit

extension UIColor {
    static var primary: UIColor {
        get {
            UIColor(dynamicProvider: { $0.userInterfaceStyle == .dark ? .white : .black })
        }
    }
}

