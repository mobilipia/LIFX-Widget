//
//  SettingsPersistanceManager.swift
//  LiFXWidget
//
//  Created by Maxime de Chalendar on 08/08/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import Foundation

class SettingsPersistanceManager {
    // MARK: Properties
    // FIXME: Replace class func with class let when supported
    class func NSUserDefaultsSuiteName() -> String { return "group.LiFXWidgetSharingDefaults" }
    class func NSUserDefaultsLightsKey() -> String { return "Lights" }
    class func NSUserDefaultsColoursKey() -> String { return "Colours" }

    
    // MARK: Lights persistance
    class func savedLights() -> [Light] {
        let userDefaults = NSUserDefaults(suiteName: NSUserDefaultsSuiteName())
        
        // FIXME: Replace the current archiving system with NSKeyedUnarchiver
        /*
        ** Archiving data in companion app and unarchiving it
        ** in the widget (or vice versa) will result of a crash
        ** of NSKeyedUnarchiver.unarchiveObjectWithData().
        **
        ** Persistance also doesn't work using Swift's array
        ** or dictionaries. I worked around that using NSArray
        ** and NSDictionary instances until I figure out
        ** a solution to get NSKeyedUnarchiver to work.
        */
//        if let lightsData = userDefaults.objectForKey(NSUserDefaultsLightsKey()) as? NSData {
//            if let lights = NSKeyedUnarchiver.unarchiveObjectWithData(lightsData) as? [Light] {
//                return lights
        
        var lights: [Light] = []
        if let lightsDictionaryArray = userDefaults.objectForKey(NSUserDefaultsLightsKey()) as? NSArray {
            var lights: [Light] = []
            for lightDictionary in lightsDictionaryArray {
                let light = Light(dictionary: lightDictionary as NSDictionary)
                lights.append(light)
            }
            return lights
        }
        return []
    }
    
    class func saveLights(lights: [Light]) {
        let userDefaults = NSUserDefaults(suiteName: NSUserDefaultsSuiteName())

        // FIXME: See SettingsPersistanceManager.savedLights()
//        let lightsData = NSKeyedArchiver.archivedDataWithRootObject(lights)
//        userDefaults.setObject(lightsData, forKey: NSUserDefaultsLightsKey())

        var lightsDictionaryArray = NSMutableArray()
        for light in lights {
            let lightDictionary = light.toDictionary()
            lightsDictionaryArray.addObject(lightDictionary)
        }
        userDefaults.setObject(lightsDictionaryArray, forKey: NSUserDefaultsLightsKey())
        userDefaults.synchronize()
    }
    
    class func addLight(light: Light) {
        var lights = savedLights()
        lights.append(light)
        saveLights(lights)
    }
    
    class func removeLight(light: Light) {
        var lights = savedLights()
        lights.remove(light)
        saveLights(lights)
    }
    
    class func updateLight(light: Light, withName name: String) {
        var lights = savedLights()
        if let index = find(lights, light) {
            light.friendlyName = name
            lights[index] = light
            saveLights(lights)
        }
    }
    
    class func hasLightForLifxTarget(lifxTarget: LFXLightTarget) -> Bool {
        var matchingTarget: Light?
        if let lifxLight = lifxTarget as? LFXLight {
            matchingTarget = savedLights().filter {
                $0.deviceID == lifxLight.deviceID
            }.firstObject()
        }
        if let lifxCollection = lifxTarget as? LFXTaggedLightCollection {
            matchingTarget = savedLights().filter {
                $0.collectionTag == lifxCollection.tag
            }.firstObject()
        }
        return (matchingTarget != nil)
    }
    
    
    // MARK: Colours persistance
    class func savedColours() -> [LFXHSBKColor] {
        let userDefaults = NSUserDefaults(suiteName: NSUserDefaultsSuiteName())
        if let coloursData = userDefaults.objectForKey(NSUserDefaultsColoursKey()) as? NSData {
            if let colours = NSKeyedUnarchiver.unarchiveObjectWithData(coloursData) as? [LFXHSBKColor] {
                return colours
            }
        }
        return []
    }
    
    class func saveColours(colours: [LFXHSBKColor]) {
        let userDefaults = NSUserDefaults(suiteName: NSUserDefaultsSuiteName())
        let coloursData = NSKeyedArchiver.archivedDataWithRootObject(colours)
        userDefaults.setObject(coloursData, forKey: NSUserDefaultsColoursKey())
        userDefaults.synchronize()
    }
    
    class func addColour(colour: LFXHSBKColor) {
        var colours = savedColours()
        colours.append(colour)
        saveColours(colours)
    }
    
    class func removeColour(colour: LFXHSBKColor) {
        var colours = savedColours()
        colours.remove(colour)
        saveColours(colours)
    }
    
    class func updateColour(colour: LFXHSBKColor, withColour newColour: LFXHSBKColor) {
        var colours = savedColours()
        if let index = find(colours, colour) {
            colours[index] = newColour
            saveColours(colours)
        }
    }
}