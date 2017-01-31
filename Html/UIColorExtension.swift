//
//  UIColorExtension.swift
//  Html
//
//  Created by Łukasz Majchrzak on 19/03/16.
//  Copyright © 2016 Łukasz Majchrzak. All rights reserved.
//

import UIKit

extension UIColor {
    static var satModifier: CGFloat   { return 0.75 }
    static var alphaModifier: CGFloat { return 1.0 }
    class func appColors() -> [UIColor] {
        return [
            UIColor(hue: 177.0/360.0, saturation: 0.52 * satModifier, brightness: 0.74, alpha: 1.0 * alphaModifier),
            UIColor(hue: 218.0/360.0, saturation: 0.58 * satModifier, brightness: 0.72, alpha: 1.0 * alphaModifier),
            UIColor(hue: 37.0/360.0,  saturation: 0.75 * satModifier, brightness: 0.94, alpha: 1.0 * alphaModifier),
            UIColor(hue: 9.0/360.0,   saturation: 0.68 * satModifier, brightness: 0.87, alpha: 1.0 * alphaModifier)
            ]
    }
}
