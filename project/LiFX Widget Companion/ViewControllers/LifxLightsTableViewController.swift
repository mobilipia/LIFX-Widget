//
//  LifxLightsTableViewController.swift
//  LiFXWidget
//
//  Created by Maxime de Chalendar on 03/08/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import UIKit

class LifxLightsTableViewController : UITableViewController,
LFXLightCollectionObserver, LFXLightObserver
{
    var lights: [LFXLight] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startMonitoringLights()
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let light = lights[indexPath.row]
        SettingsPersistanceManager.addLight(Light(friendlyName: light.label(), deviceID: light.deviceID))
        navigationController.popViewControllerAnimated(true)
    }
    
    // MARK: LFXLightCollectionObserver
    func lightCollection(lightCollection: LFXLightCollection!, didAddLight light: LFXLight!) {
        if (SettingsPersistanceManager.hasLightForLifxLight(light) == false) {
            lights.append(light)
            tableView.reloadData()
        }
    }
    
    func lightCollection(lightCollection: LFXLightCollection!, didRemoveLight light: LFXLight!)  {
        lights.remove(light!)
        tableView.reloadData()
    }
    
    func startMonitoringLights() {
        var context = LFXClient.sharedClient().localNetworkContext
        var lifxLights = context.allLightsCollection
        lifxLights.addLightCollectionObserver(self)
        
        for lifxLight in lifxLights.lights as [LFXLight] {
            self.lightCollection(lifxLights, didAddLight: lifxLight as LFXLight)
        }
    }
}
