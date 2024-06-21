//
//  UIFont+ext.swift
//  Strivvy
//
//  Created by Gustavo Munhoz Correa on 21/06/24.
//

import UIKit

extension UIFont {
    /// Returns a font with the specified traits, or nil if none.
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = self.fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0)
    }
}
