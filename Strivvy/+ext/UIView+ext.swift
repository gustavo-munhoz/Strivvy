//
//  UIView+ext.swift
//  Strivvy
//
//  Created by Gustavo Munhoz Correa on 10/06/24.
//

import UIKit

extension UIView {
    static func spacer(for layout: NSLayoutConstraint.Axis = .horizontal) -> UIView {
        let spacer = UIView()
        spacer.isUserInteractionEnabled = false
        spacer.setContentHuggingPriority(.fittingSizeLevel, for: layout)
        spacer.setContentCompressionResistancePriority(.fittingSizeLevel, for: layout)
        
        return spacer
    }

}
