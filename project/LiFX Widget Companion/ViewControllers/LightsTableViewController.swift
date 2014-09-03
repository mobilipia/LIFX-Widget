//
//  LightsTableViewController.swift
//  LiFXWidget
//
//  Created by Maxime de Chalendar on 03/08/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import UIKit

var LightsTableViewCellIdentifier = "LightTableViewCell"
var LightViewControllerSegue = "LightViewControllerSegue"

class LightsTableViewController : UITableViewController {
    
    // MARK: Properties
    var lights: [Light] {
    return SettingsPersistanceManager.savedLights()
    }
    
    
    // MARK: UIViewController
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // FIXME: This is crap
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == LightViewControllerSegue) {
            let lightViewController = segue.destinationViewController as LightViewController
            configureLightViewControllerWithSelectedLight(lightViewController)
        }
    }
    
    
    // MARK: UITableViewDataSource, UITableViewDelegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countElements(lights)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(LightsTableViewCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        let light = lights[indexPath.row]
        configureCell(cell, withLight:light)
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            removeLightAtIndexPath(indexPath)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
        }
    }
    
    
    // MARK: Convenience methods
    func configureCell(cell: UITableViewCell, withLight light: Light) {
        cell.textLabel?.text = light.friendlyName
    }

    func removeLightAtIndexPath(indexPath: NSIndexPath) {
        var light = lights[indexPath.row]
        SettingsPersistanceManager.removeLight(light)
    }
    
    func configureLightViewControllerWithSelectedLight(lightViewController: LightViewController) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow() {
            let selectedLight = lights[selectedIndexPath.row]
            lightViewController.light = selectedLight
        }
    }
}
