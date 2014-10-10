//
//  LightsTableViewController.swift
//  LiFXWidget
//
//  Created by Maxime de Chalendar on 03/08/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import UIKit

let LifxTargetTableViewCellIdentifier = "LifxTargetTableViewCell"
let LightViewControllerSegue = "LightViewControllerSegue"
let LifxLightPickerSegue = "LifxLightViewControllerSegue"

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
        configureView()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == LifxLightPickerSegue {
            let lifxLightPicker = segue.destinationViewController as LifxLightsTableViewController
            configureLifxLightPicker(lifxLightPicker)
        }
        
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier(LifxTargetTableViewCellIdentifier, forIndexPath: indexPath) as LifxTargetTableViewCell
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
    func configureView() {
        emptyImage = UIImage(named: "large-lightbulb")
        emptyTitle = "No lights configured"
        emptyButtonTitle = "Add some by pressing the '+' button"
        tintColor = UIColor(red: 244/CGFloat(255), green: 144/CGFloat(255), blue: 255/CGFloat(255), alpha: 1)
    }
    
    func removeLightAtIndexPath(indexPath: NSIndexPath) {
        var light = lights[indexPath.row]
        SettingsPersistanceManager.removeLight(light)
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

    func displayLifxLightPicker() {
        performSegueWithIdentifier(LifxLightPickerSegue, sender: nil)
    }
    
    func configureLifxLightPicker(lifxLightPicker: LifxLightsTableViewController) {
        lifxLightPicker.onLightSelection = { lifxLight in
            self.saveLifxLight(lifxLight)
            self.tableView.reloadData()
            self.dismissLifxLightPicker()
        }
        lifxLightPicker.onCollectionSelection = { lifxCollection in
            self.saveLifxCollection(lifxCollection)
            self.tableView.reloadData()
            self.dismissLifxLightPicker()
        }
    }
    
    func saveLifxLight(lifxLight: LFXLight) {
        let light = Light(friendlyName: lifxLight.label(), deviceID: lifxLight.deviceID)
        SettingsPersistanceManager.addLight(light)
    }
    
    func saveLifxCollection(lifxCollection: LFXTaggedLightCollection) {
        let light = Light(friendlyName: lifxCollection.tag, collectionTag: lifxCollection.tag)
        SettingsPersistanceManager.addLight(light)
    }
    
    func dismissLifxLightPicker() {
        navigationController?.popViewControllerAnimated(true)
    }
}
