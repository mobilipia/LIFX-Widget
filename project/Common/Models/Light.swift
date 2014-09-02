//
//  Light.swift
//  LiFXWidget
//
//  Created by Maxime de Chalendar on 30/07/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import Foundation

class Light : NSObject, Equatable, NSCoding {
    // MARK: Properties
    var friendlyName: String
    var deviceID: String
    var lifxLight: LFXLight?

    var isAvailable: Bool {
        return (lifxLight != nil)
    }
    
    // MARK: Init
    init(friendlyName: String, deviceID: String) {
        self.friendlyName = friendlyName
        self.deviceID = deviceID
        super.init()
    }
    
    // MARK: NSCoding
    required init(coder aDecoder: NSCoder) {
        friendlyName = aDecoder.decodeObjectForKey("friendlyName") as String
        deviceID = aDecoder.decodeObjectForKey("deviceID") as String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(friendlyName, forKey: "friendlyName")
        aCoder.encodeObject(deviceID, forKey: "deviceID")
    }
}

// MARK: Equatable
func == (lhs: Light, rhs: Light) -> Bool {
    return lhs.deviceID == rhs.deviceID
}

