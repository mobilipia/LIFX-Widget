//
//  ColoursTableViewController.swift
//  LiFXWidget
//
//  Created by Maxime de Chalendar on 03/08/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import UIKit

var ColourTableViewCellIdentifier = "ColourTableViewCellIdentifier"
var ColourViewControllerSegue = "ColourViewControllerSegue"

class ColoursTableViewController : UITableViewController {
    
    // MARK: Properties
    var colours: [LFXHSBKColor] {
        return SettingsPersistanceManager.savedColours()
    }
    

    // MARK: UIViewController
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // FIXME: This is crap
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == ColourViewControllerSegue) {
            let colourViewController = segue.destinationViewController as ColourViewController
            configureColourViewControllerWithSelectedColour(colourViewController)
        }
    }
    
    
    // MARK: UITableViewDataSource, UITableViewDelegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countElements(colours)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ColourTableViewCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        let colour = colours[indexPath.row]
        configureCell(cell, withColour:colour)
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            removeColourAtIndexPath(indexPath)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
        }
    }
    
    
    // MARK: Convenience methods
    func configureCell(cell: UITableViewCell, withColour colour: LFXHSBKColor) {
        cell.backgroundColor = colour.UIColor()
    }
    
    func removeColourAtIndexPath(indexPath: NSIndexPath) {
        var colour = colours[indexPath.row]
        SettingsPersistanceManager.removeColour(colour)
    }
    
    func configureColourViewControllerWithSelectedColour(colourViewController: ColourViewController) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow() {
            let selectedColour = colours[selectedIndexPath.row]
            colourViewController.colour = selectedColour
        }
    }
}
