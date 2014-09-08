//
//  ColoursTableViewController.swift
//  LiFXWidget
//
//  Created by Maxime de Chalendar on 03/08/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import UIKit

var ColourTableViewCellIdentifier = "ColourTableViewCellIdentifier"
var ColourPickerSegue = "ColourViewControllerSegue"
var NewColourPickerSegue = "NewColourViewControllerSegue"

class ColoursTableViewController : GenericTableViewController
{
    
    // MARK: Properties
    var colours: [LFXHSBKColor] {
        return SettingsPersistanceManager.savedColours()
    }
    

    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == ColourPickerSegue || segue.identifier == NewColourPickerSegue {
            let colourPicker = segue.destinationViewController as ColourViewController
            configureColourPickerWithSelectedColour(colourPicker)
        }
    }
    
    
    // MARK: UITableViewDataSource, UITableViewDelegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colours.count
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
            tableView.reloadEmptyDataSet()
        }
    }
    
    
    // MARK: DZNEmptyDataSetDelegate
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        displayColourPicker()
    }
    

    // MARK: Convenience methods
    func configureView() {
        emptyImage = UIImage(named: "large-colour-wheel")
        emptyTitle = "No colours configured"
        emptyButtonTitle = "Add some by pressing the '+' button"
        tintColor = UIColor(red: 5/CGFloat(255), green: 222/CGFloat(255), blue: 255/CGFloat(255), alpha: 1)
    }
    
    func configureCell(cell: UITableViewCell, withColour colour: LFXHSBKColor) {
        cell.contentView.backgroundColor = colour.UIColor()
    }
    
    func removeColourAtIndexPath(indexPath: NSIndexPath) {
        var colour = colours[indexPath.row]
        SettingsPersistanceManager.removeColour(colour)
    }
    
    func configureColourPickerWithSelectedColour(colourPicker: ColourViewController) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow() {
            let selectedColour = colours[selectedIndexPath.row]
            colourPicker.colour = selectedColour
        }

        colourPicker.onColourSelection = { initialColour, newColour in
            self.saveColour(initialColour, newColour: newColour)
            self.tableView.reloadData()
            self.dismissColourPicker()
        }
    }
    
    func saveColour(initialColour: LFXHSBKColor?, newColour: LFXHSBKColor) {
        if let initialColour = initialColour {
            SettingsPersistanceManager.updateColour(initialColour, withColour: newColour)
        } else {
            SettingsPersistanceManager.addColour(newColour)
        }
    }
    
    func dismissColourPicker() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func displayColourPicker() {
        performSegueWithIdentifier(NewColourPickerSegue, sender: nil)
    }
}
