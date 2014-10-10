//
//  LifxLightsTableViewController.swift
//  LiFXWidget
//
//  Created by Maxime de Chalendar on 03/08/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import UIKit

enum LifxLightTableViewSection : Int {
    case Light = 0
    case Collection = 1
    
    func title() -> String {
        switch self {
        case .Light:
            return "Lights"
        case .Collection:
            return "Collections"
        }
    }
    
    static func numberOfSections() -> Int {
        return 2
    }
}

var LifxLightsTableViewCellIdentifier = "LifxLightTableViewCell"

class LifxLightsTableViewController : GenericTableViewController,
LFXLightCollectionObserver, LFXLightObserver,
LFXNetworkContextObserver
{
    
    // MARK: Properties
    var lights: [LFXLight] = []
    var collections: [LFXTaggedLightCollection] = []
    var onLightSelection: (LFXLight->())?
    var onCollectionSelection: (LFXTaggedLightCollection->())?
    
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        startMonitoringLightsAndCollections()
    }
    
    
    // MARK: UITableViewDataSource, UITableViewDelegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return LifxLightTableViewSection.numberOfSections()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionObject = LifxLightTableViewSection.fromRaw(section)!
        
        switch sectionObject {
        case .Light:
            return lights.count
        case .Collection:
            return collections.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let sectionObject = LifxLightTableViewSection.fromRaw(indexPath.section)!
        let cell = tableView.dequeueReusableCellWithIdentifier(LifxLightsTableViewCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        switch sectionObject {
        case .Light:
            let light = lights[indexPath.row]
            configureCell(cell, withLight:light)
        case .Collection:
            let collection = collections[indexPath.row]
            configureCell(cell, withCollection:collection)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, customTitleForHeaderInSection section: Int) -> String? {
        let sectionObject = LifxLightTableViewSection.fromRaw(section)!
        return sectionObject.title()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sectionObject = LifxLightTableViewSection.fromRaw(indexPath.section)!
        
        switch sectionObject {
        case .Light:
            let light = lights[indexPath.row]
            onLightSelection?(light)
        case .Collection:
            let collection = collections[indexPath.row]
            onCollectionSelection?(collection)
        }
    }
    
    
    // MARK: LFXLightCollectionObserver
    func lightCollection(lightCollection: LFXLightCollection!, didAddLight light: LFXLight!) {
        if (SettingsPersistanceManager.hasLightForLifxTarget(light) == false) {
            lights.append(light)
            tableView.reloadData()
        }
    }
    
    func lightCollection(lightCollection: LFXLightCollection!, didRemoveLight light: LFXLight!)  {
        lights.remove(light!)
        tableView.reloadData()
    }
    
    
    // MARK: LFXNetworkContextObserver
    func networkContext(networkContext: LFXNetworkContext!, didAddTaggedLightCollection collection: LFXTaggedLightCollection!) {
        if (SettingsPersistanceManager.hasLightForLifxTarget(collection) == false) {
            collections.append(collection)
            tableView.reloadData()
        }
    }
    
    func networkContext(networkContext: LFXNetworkContext!, didRemoveTaggedLightCollection collection: LFXTaggedLightCollection!) {
        collections.remove(collection!)
        tableView.reloadData()
    }
    
    
    // MARK: Convenience methods
    func configureView() {
        emptyImage = UIImage(named: "no-lifx")
        emptyTitle = "Can't find any LIFX on the network"
        emptyDescription = "Are you on the same WiFi network ?"
        tintColor = UIColor(red: 132/CGFloat(255), green: 235/CGFloat(255), blue: 147/CGFloat(255), alpha: 1)
    }
    
    func startMonitoringLightsAndCollections() {
        var context = LFXClient.sharedClient().localNetworkContext
        context.addNetworkContextObserver(self)
        for collection in context.taggedLightCollections as [LFXTaggedLightCollection] {
            self.networkContext(context, didAddTaggedLightCollection: collection)
        }
        
        var lifxLights = context.allLightsCollection
        lifxLights.addLightCollectionObserver(self)
        for lifxLight in lifxLights.lights as [LFXLight] {
            self.lightCollection(lifxLights, didAddLight: lifxLight as LFXLight)
        }
    }
    
    func configureCell(cell: UITableViewCell, withLight light: LFXLight) {
        cell.textLabel?.text = light.label()
    }
    
    func configureCell(cell: UITableViewCell, withCollection collection: LFXTaggedLightCollection) {
        cell.textLabel?.text = collection.tag
    }
    
}
