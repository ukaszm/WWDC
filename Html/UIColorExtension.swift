//
//  UIColorExtension.swift
//  Html
//
//  Created by Łukasz Majchrzak on 19/03/16.
//  Copyright © 2016 Łukasz Majchrzak. All rights reserved.
//

import UIKit

extension UIColor {
    var redValue: CGFloat {
        return CoreImage.CIColor(color: self).red
    }
    var greenValue: CGFloat {
        return CoreImage.CIColor(color: self).green
    }
    var blueValue: CGFloat {
        return CoreImage.CIColor(color: self).blue
    }
    
//    class func appPastelsColors() -> [UIColor] {
//        return UIColor.colorsWithAlpha([
//            UIColor(colorLiteralRed: 64.0/255.0, green: 188.0/255.0, blue: 188.0/255.0, alpha: 1.0),  // turquoise
//            UIColor(colorLiteralRed: 234.0/255.0, green: 203.0/255.0, blue: 95.0/255.0, alpha: 1.0),  // yellow
//            UIColor(colorLiteralRed: 229.0/255.0, green: 115.0/255.0, blue: 104.0/255.0, alpha: 1.0), // salmon
//            UIColor(colorLiteralRed: 125.0/255.0, green: 74.0/255.0, blue: 130.0/255.0, alpha: 1.0),  // purple
//            UIColor(colorLiteralRed: 70.0/255.0, green: 112.0/255.0, blue: 196.0/255.0, alpha: 1.0)   // blue
//        ], alpha: 0.08)
//    }
//    
//    class func appSemiSaturatedColors() -> [UIColor] {
//        return UIColor.colorsWithAlpha([
//            UIColor(colorLiteralRed: 118.0/255.0, green: 168.0/255.0, blue: 63.0/255.0, alpha: 1.0), // green
//            UIColor(colorLiteralRed: 245.0/255.0, green: 181.0/255.0, blue: 53.0/255.0, alpha: 1.0), // yellow
//            UIColor(colorLiteralRed: 228.0/255.0, green: 123.0/255.0, blue: 54.0/255.0, alpha: 1.0), // orange
//            UIColor(colorLiteralRed: 212.0/255.0, green: 65.0/255.0, blue: 50.0/255.0, alpha: 1.0),  // red
//            UIColor(colorLiteralRed: 131.0/255.0, green: 69.0/255.0, blue: 163.0/255.0, alpha: 1.0), // purple
//            UIColor(colorLiteralRed: 56.0/255.0, green: 115.0/255.0, blue: 212.0/255.0, alpha: 1.0)  // blue
//        ], alpha: 0.08)
//    }
//    
//    class func appVerySaturatedColors() -> [UIColor] {
//        return UIColor.colorsWithAlpha([
//            UIColor(colorLiteralRed: 99.0/255.0, green: 177.0/255.0, blue: 60.0/255.0, alpha: 1.0),  // green
//            UIColor(colorLiteralRed: 253.0/255.0, green: 182.0/255.0, blue: 17.0/255.0, alpha: 1.0), // yellow
//            UIColor(colorLiteralRed: 242.0/255.0, green: 113.0/255.0, blue: 26.0/255.0, alpha: 1.0), // orange
//            UIColor(colorLiteralRed: 228.0/255.0, green: 20.0/255.0, blue: 28.0/255.0, alpha: 1.0),  // red
//            UIColor(colorLiteralRed: 142.0/255.0, green: 51.0/255.0, blue: 137.0/255.0, alpha: 1.0), // purple
//            UIColor(colorLiteralRed: 18.0/255.0, green: 151.0/255.0, blue: 216.0/255.0, alpha: 1.0)  // blue
//        ], alpha: 0.08)
//    }
//    
//    class func appColors_GBYR() -> [UIColor] {
//        return UIColor.colorsWithAlpha([
//            UIColor(colorLiteralRed: 91.0/255.0, green: 188.0/255.0, blue: 183.0/255.0, alpha: 1.0),  // green
//            UIColor(colorLiteralRed: 78.0/255.0, green: 117.0/255.0, blue: 184.0/255.0, alpha: 1.0), // blue
//            UIColor(colorLiteralRed: 240.0/255.0, green: 172.0/255.0, blue: 60.0/255.0, alpha: 1.0), // yellow
//            UIColor(colorLiteralRed: 223.0/255.0, green: 95.0/255.0, blue: 71.0/255.0, alpha: 1.0),  // red
//        ], alpha: 0.78)
//    }
    
    static var satModifier: CGFloat { return 0.75 }
    static var alphaModifier: CGFloat { return 1.0 }
    class func appColors_test() -> [UIColor] {
        return [
            UIColor(hue: 177.0/360.0, saturation: 0.52 * satModifier, brightness: 0.74, alpha: 1.0 * alphaModifier),
            UIColor(hue: 218.0/360.0, saturation: 0.58 * satModifier, brightness: 0.72, alpha: 1.0 * alphaModifier),
            UIColor(hue: 37.0/360.0,  saturation: 0.75 * satModifier, brightness: 0.94, alpha: 1.0 * alphaModifier),
            UIColor(hue: 9.0/360.0,   saturation: 0.68 * satModifier, brightness: 0.87, alpha: 1.0 * alphaModifier)
            ]
    }
    
    class func colorsWithAlpha(_ colors: [UIColor], alpha: CGFloat) -> [UIColor] {
        return colors.map { UIColor(red: $0.redValue, green: $0.greenValue, blue: $0.blueValue, alpha: alpha) }
    }
    
    class func appRowsColors() -> [UIColor] {
        //return [UIColor.init(white: 245.0/255, alpha: 1.0), UIColor.whiteColor() ]
        //return UIColor.appColors_GBYR()
        //return UIColor.appPastelsColors()
        //return UIColor.appVerySaturatedColors()
        //return UIColor.appSemiSaturatedColors()
        return UIColor.appColors_test()
    }
}
