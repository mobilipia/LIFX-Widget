//
//  TodayViewController.swift
//  LiFXWidgetExtension
//
//  Created by Maxime de Chalendar on 23/07/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import UIKit
import NotificationCenter


enum CollectionViewSection : Int {
    case Light = 0
    case Colour = 1
    
    func cellIdentifier() -> String {
        switch self {
        case .Light:
            return LightCollectionViewCell.cellIdentifier()
        case .Colour:
            return ColourCollectionViewCell.cellIdentifier()
        }
    }
    
    static func numberOfSections() -> Int {
        return 2
    }
}


class ExtensionViewController: UIViewController,
UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,
LFXLightCollectionObserver, LFXLightObserver,
NCWidgetProviding {
    
    // MARK: Properties
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var toogleSwitch: UISwitch!
    
    var colours: [LFXHSBKColor] = []
    var selectedColourIndex: Int?
    
    var lights: [Light] = []
    var selectedLightIndex: Int?
    var selectedLight: Light? {
    if let lightIndex = selectedLightIndex {
        return lights[lightIndex]
    } else {
        return nil
    }
    }

    
    // MARK: UIViewController
    required init(coder aDecoder: NSCoder) {
        SettingsPersistanceManager.initHardCodedLights()
        SettingsPersistanceManager.initHardCodedColours()
        
        lights = SettingsPersistanceManager.savedLights()
        colours = SettingsPersistanceManager.savedColours()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startMonitoringLights()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }

    
    // MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return CollectionViewSection.numberOfSections()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionObject = CollectionViewSection.fromRaw(section)!

        switch sectionObject {
        case .Light:
            return countElements(lights)
        case .Colour:
            return countElements(colours)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let sectionObject = CollectionViewSection.fromRaw(indexPath.section)!
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(sectionObject.cellIdentifier(), forIndexPath: indexPath) as UICollectionViewCell

        switch sectionObject {
        case .Light:
            configureLightCell(cell as LightCollectionViewCell, atIndex: indexPath.row)
        case .Colour:
            configureColourCell(cell as ColourCollectionViewCell, atIndex: indexPath.row)
        }

        return cell
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, insetForSectionAtIndex section: Int) -> UIEdgeInsets  {
        let flowLayout = collectionViewLayout as UICollectionViewFlowLayout
        let defaultInsets = flowLayout.sectionInset

        let width = CGRectGetWidth(collectionView.bounds)
        let cellWidth = flowLayout.itemSize.width
        let spacingWidth = flowLayout.minimumInteritemSpacing
        
        let numberOfCells = self.collectionView(collectionView, numberOfItemsInSection: section)
        let numberOfSpaces = numberOfCells - 1
        
        var edgeInsets = (width - (cellWidth * CGFloat(numberOfCells) + spacingWidth * CGFloat(numberOfSpaces))) / 2.0
        edgeInsets = max(edgeInsets, 5)
        return UIEdgeInsetsMake(defaultInsets.top, edgeInsets, defaultInsets.bottom, edgeInsets)
    }
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        let sectionObject = CollectionViewSection.fromRaw(indexPath.section)!

        switch sectionObject {
        case .Light:
            selectLightAtIndex(indexPath.row)
        case .Colour:
            selectColourAtIndex(indexPath.row)
        }
        
        updateView()
    }
    
    
    // MARK: LFXLightCollectionObserver
    func lightCollection(lightCollection: LFXLightCollection!, didAddLight lifxLight: LFXLight!)  {
        if let light = lightForLifxLight(lifxLight) {
            lifxLight.addLightObserver(self)
            light.lifxLight = lifxLight
            updateView()
        }
    }
    
    func lightCollection(lightCollection: LFXLightCollection!, didRemoveLight lifxLight: LFXLight!)  {
        if let light = lightForLifxLight(lifxLight) {
            lifxLight.removeLightObserver(self)
            light.lifxLight = nil
            updateView()
        }
    }
    
    
    //- MARK: LFXLightObserver
    func light(lifxLight: LFXLight!, didChangePowerState powerState: LFXPowerState)  {
        if lightForLifxLight(lifxLight)?.deviceID == selectedLight?.deviceID {
            updateView()
        }
    }
    

    // MARK: NCWidgetProviding
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // TODO: Update view
        completionHandler(NCUpdateResult.NoData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }

    
    // MARK: User interactions
    @IBAction func toogledSwitch(sender: UISwitch) {
        updateSelectedLightState()
        updateView()
    }
    

    // MARK: Convenience methods - Light related
    func startMonitoringLights() {
        var context = LFXClient.sharedClient().localNetworkContext
        var lifxLights = context.allLightsCollection
        lifxLights.addLightCollectionObserver(self)
    
        for lifxLight in lifxLights.lights {
            self.lightCollection(lifxLights, didAddLight: lifxLight as LFXLight)
        }
    }

    func lightForLifxLight(lifxLight: LFXLight) -> Light? {
        return lights.filter {
            return $0.deviceID == lifxLight.deviceID
        }.firstObject()
    }
    
    func updateSelectedLightState() {
        if let powerState = LFXPowerState.fromRaw(UInt(toogleSwitch.on)) {
            selectedLight?.lifxLight?.setPowerState(powerState)
        }
    }
    
    
    // MARK: Convenience methods - Updating UI informations
    func updateView() {
        collectionView.reloadData()
        updateCollectionViewHeight()
        updateToogleFromSelectedLight()
    }
    
    func updateCollectionViewHeight() {
        collectionViewHeightConstraint.constant = collectionView.contentSize.height
    }
    
    func updateToogleFromSelectedLight() {
        if let currentLight = selectedLight {
            if let lifxLight = currentLight.lifxLight {
                switch lifxLight.powerState() {
                case .On:
                    updateAvailableToogleWithStatus(isOn: true)
                case .Off:
                    updateAvailableToogleWithStatus(isOn: false)
                }
            } else {
                updateUnavailableToogle()
            }
        } else {
            updateUnavailableToogle()
        }
    }
    
    func updateAvailableToogleWithStatus(isOn status: Bool) {
        toogleSwitch.enabled = true
        toogleSwitch.on = status
    }
    
    func updateUnavailableToogle() {
        toogleSwitch.enabled = false
        toogleSwitch.on = false
    }
    
    func configureLightCell(cell: LightCollectionViewCell, atIndex index: Int) {
        let light = lights[index]
        let isAvailable = light.isAvailable
        let isSelected = (selectedLightIndex == index)
        cell.configureWithLight(light, isEnabled: isAvailable, isSelected: isSelected)
    }
    
    func configureColourCell(cell: ColourCollectionViewCell, atIndex index: Int) {
        let colour = colours[index]
        let hasSelectedLight = (selectedLightIndex != nil)
        let isSelected = (selectedColourIndex == index)
        cell.configureWithColour(colour.UIColor(), isEnabled: hasSelectedLight, isSelected: isSelected)
    }
    
    func selectLightAtIndex(index: Int) {
        let light = lights[index]
        if light.isAvailable {
            selectedLightIndex = index
            selectedColourIndex = nil
        }
    }
    
    func selectColourAtIndex(index: Int) {
        if let selectedLight = selectedLight {
            selectedColourIndex = index
            let selectedColour = colours[index]
            selectedLight.lifxLight?.setColor(selectedColour)
        }
    }


}
