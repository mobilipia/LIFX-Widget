//
//  UIColorExtension.swift
//  LiFX Widget
//
//  Created by Maxime de Chalendar on 04/09/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    // Returns (hue, saturation, brightness, alpha), each in the [0,1] range
    // (-1, 0, 0, 0) on failure
    func HSBAComponents() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) == false {
            return (-1, 0, 0, 0)
        }
        return (hue, saturation, brightness, alpha)
    }
    
    class func randomColor(alpha: CGFloat = 1) -> UIColor {
        let (r, g, b) = (
            CGFloat(arc4random_uniform(255)) / 255,
            CGFloat(arc4random_uniform(255)) / 255,
            CGFloat(arc4random_uniform(255)) / 255
        )
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}
