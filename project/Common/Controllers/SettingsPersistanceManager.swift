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
        if let lightsData = userDefaults.objectForKey(NSUserDefaultsLightsKey()) as? NSData {
            if let lights = NSKeyedUnarchiver.unarchiveObjectWithData(lightsData) as? [Light] {
                return lights
            }
        }
        return []
    }
    
    class func saveLights(lights: [Light]) {
        let userDefaults = NSUserDefaults(suiteName: NSUserDefaultsSuiteName())
        let lightsData = NSKeyedArchiver.archivedDataWithRootObject(lights)
        userDefaults.setObject(lightsData, forKey: NSUserDefaultsLightsKey())
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
    
    class func hasLightForLifxLight(lifxLight: LFXLight) -> Bool {
        let matchingLight = savedLights().filter {
            $0.deviceID == lifxLight.deviceID
        }.firstObject()
        return (matchingLight != nil)
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
    
    
    // FIXME: Remove these functions
    /*
    ** Archiving data in companion app and unarchiving it
    ** in the widget (or vice versa) will result of a crash
    ** of NSKeyedUnarchiver.unarchiveObjectWithData().
    ** Temporary, lights and colours are hardcoded and
    ** initHardCodedLights() / initHardCodedColours()
    ** are being called each time you open the widget or companion app.
    **
    ** This way, the NSKeyedUnarchiver.unarchiveObjectWithData()
    ** doesn't complain any more, since the data is archived and
    ** unarchived within the same app.
    */
    class func initHardCodedLights() {
        saveLights([
            Light(friendlyName: "Bed room", deviceID: "Some identifer"),
            Light(friendlyName: "Living room", deviceID: "Get it thought lifx-http"),
            Light(friendlyName: "Office", deviceID: "GET /lights"),
            Light(friendlyName: "Kitchen", deviceID: "I guess you got it..."),
        ])
    }
    
    class func initHardCodedColours() {
        saveColours([
            LFXHSBKColor(hue: 10, saturation: 1, brightness: 0.6),
            LFXHSBKColor(hue: 50, saturation: 1, brightness: 0.6),
            LFXHSBKColor(hue: 100, saturation: 1, brightness: 0.6),
            LFXHSBKColor(hue: 150, saturation: 1, brightness: 0.6),
            LFXHSBKColor(hue: 200, saturation: 1, brightness: 0.6),
            LFXHSBKColor(hue: 0, saturation: 0, brightness: 0.6)
        ])
    }
}