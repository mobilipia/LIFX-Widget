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
    var deviceID: String?
    var collectionTag: String?

    var lifxLight: LFXLight?
    var lifxCollection: LFXTaggedLightCollection?
    
    var target: LFXLightTarget? {
        return lifxLight ?? lifxCollection
    }
    var isAvailable: Bool {
        return (target != nil)
    }
    
    // MARK: Init
    init(friendlyName: String, deviceID: String) {
        self.friendlyName = friendlyName
        self.deviceID = deviceID
        super.init()
    }
    
    init(friendlyName: String, collectionTag: String) {
        self.friendlyName = friendlyName
        self.collectionTag = collectionTag
        super.init()
    }
    
    // MARK: NSCoding
    required init(coder aDecoder: NSCoder) {
        friendlyName = aDecoder.decodeObjectForKey("friendlyName") as String
        deviceID = aDecoder.decodeObjectForKey("deviceID") as String?
        collectionTag = aDecoder.decodeObjectForKey("collectionTag") as String?
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(friendlyName, forKey: "friendlyName")
        if let deviceID = deviceID {
            aCoder.encodeObject(deviceID, forKey: "deviceID")
        }
        if let collectionTag = collectionTag {
            aCoder.encodeObject(collectionTag, forKey: "collectionTag")
        }
    }
    
    // FIXME: Remove these two methods (see FIXME in SettingsPersistanceManager.savedLights())
    convenience init(dictionary: NSDictionary) {
        let friendlyName = dictionary["friendlyName"] as String
        if let deviceID = dictionary["deviceID"] as? String {
            self.init(friendlyName: friendlyName, deviceID: deviceID)
        } else if let collectionTag =  dictionary["collectionTag"] as? String {
            self.init(friendlyName: friendlyName, collectionTag: collectionTag)
        } else {
            self.init(friendlyName: friendlyName, deviceID: "unknownDevice")
        }
    }
    
    func toDictionary() -> NSDictionary {
        if let deviceID = deviceID {
            return NSDictionary(objects: [ friendlyName, deviceID ],
                                forKeys: [ "friendlyName", "deviceID" ])
        }
        if let collectionTag = collectionTag {
            return NSDictionary(objects: [friendlyName, collectionTag ],
                                forKeys: ["friendlyName", "collectionTag" ])
        }
        return NSDictionary()
    }
}

// MARK: Equatable
func == (lhs: Light, rhs: Light) -> Bool {
    return lhs.deviceID == rhs.deviceID
}

