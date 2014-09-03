//
//  LFXKSBKColourExtension.swift
//  LiFXWidget
//
//  Created by Maxime de Chalendar on 07/08/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import Foundation

// FIXME: Understand why Swift's compiler yells at me if I uncomment NSCoding
extension LFXHSBKColor/*: NSCoding*/ {
    
    // MARK: NSCoding
    convenience init(coder aDecoder: NSCoder) {
        let hue = CGFloat(aDecoder.decodeFloatForKey("hue"))
        let saturation = CGFloat(aDecoder.decodeFloatForKey("saturation"))
        let brightness = CGFloat(aDecoder.decodeFloatForKey("brightness"))
        let kelvin = UInt16(aDecoder.decodeIntForKey("kelvin"))
        self.init(hue:hue, saturation:saturation, brightness:brightness, kelvin:kelvin)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeFloat(Float(hue), forKey: "hue")
        aCoder.encodeFloat(Float(saturation), forKey: "saturation")
        aCoder.encodeFloat(Float(brightness), forKey: "brightness")
        aCoder.encodeInt(Int32(kelvin), forKey: "kelvin")
    }
}