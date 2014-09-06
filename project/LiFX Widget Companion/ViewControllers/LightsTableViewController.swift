//
//  LightsTableViewController.swift
//  LiFXWidget
//
//  Created by Maxime de Chalendar on 03/08/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import UIKit

let LightsTableViewCellIdentifier = "LightTableViewCell"
let LightViewControllerSegue = "LightViewControllerSegue"
let LifxLightViewControllerSegue = "LifxLightViewControllerSegue"

class LightsTableViewController : GenericTableViewController,
UITextFieldDelegate
{
    
    // MARK: Properties
    var lights: [Light] {
    return SettingsPersistanceManager.savedLights()
    }
    var displayedTextField: UITextField?
    
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyImage = UIImage(named: "large-lightbulb")
        emptyTitle = "No lights configured"
        emptyButtonTitle = "Add some by pressing the '+' button"
        tintColor = UIColor(red: 244/CGFloat(255), green: 144/CGFloat(255), blue: 255/CGFloat(255), alpha: 1)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // FIXME: This is crap
        tableView.reloadData()
    }

    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        displayedTextField = textField
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        saveLightAndDismissKeyboard()
        return true
    }
    
    
    // MARK: UIScrollView
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        saveLightAndDismissKeyboard()
    }
    
    
    // MARK: UITableViewDataSource, UITableViewDelegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lights.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(LightsTableViewCellIdentifier, forIndexPath: indexPath) as TextFieldTableViewCell
        let light = lights[indexPath.row]
        cell.configureWithLight(light)
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            removeLightAtIndexPath(indexPath)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
            tableView.reloadEmptyDataSet()
        }
    }
    
    
    // MARK: DZNEmptyDataSetDelegate
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        displayLifxLightPicker()
    }
    
    
    // MARK: User interactions
    @IBAction func tappedTableView(sender: UITapGestureRecognizer) {
        saveLightAndDismissKeyboard()
    }
    
    
    // MARK: Convenience methods
    func removeLightAtIndexPath(indexPath: NSIndexPath) {
        var light = lights[indexPath.row]
        SettingsPersistanceManager.removeLight(light)
    }
    
    func displayLifxLightPicker() {
        performSegueWithIdentifier(LifxLightViewControllerSegue, sender: nil)
    }
    
    func saveLightAndDismissKeyboard() {
        if let displayedTextField = displayedTextField {
            if let indexPath = cellIndexPathFromTextField(displayedTextField) {
                let newName = displayedTextField.text
                let light = lights[indexPath.row]
                SettingsPersistanceManager.updateLight(light, withName: newName)
            }
            displayedTextField.resignFirstResponder()
        }
    }
    
    func cellIndexPathFromTextField(textField: UITextField) -> NSIndexPath? {
        var view: UIView = textField
        while (view is UITableViewCell == false) {
            view = view.superview!
        }
        
        let cell = view as UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        return indexPath
    }
}
