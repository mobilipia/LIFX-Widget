//
//  TodayViewController.swift
//  LiFXWidgetExtension
//
//  Created by Maxime de Chalendar on 23/07/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import UIKit
import NotificationCenter


let kEmptyBulbsCollectionViewHeight: CGFloat = 100


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
DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,
LFXLightCollectionObserver, LFXLightObserver,
LFXNetworkContextObserver,
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
    
    // FIXME: Apple's SDK Bug
    /*
    ** On regular horizontal size classes, the notification center
    ** has a constant width with left and right margins. For some
    ** reason, the width of the collectionView is the same as the
    ** screen's width, as if there were no margins.
    */
    var realCollectionViewWidth: CGFloat {
        get {
            switch (traitCollection.horizontalSizeClass, traitCollection.userInterfaceIdiom) {
                case (.Regular, .Pad):
                    return 592
                case (.Regular, .Phone):
                    return 399
                default:
                    return CGRectGetWidth(collectionView.bounds)
            }
        }
    }

    
    // MARK: UIViewController
    required init(coder aDecoder: NSCoder) {
        lights = SettingsPersistanceManager.savedLights()
        colours = SettingsPersistanceManager.savedColours()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureEmptyDataSet()
        startMonitoringLightsAndCollections()
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
        if lights.isEmpty || colours.isEmpty {
            return 0
        }
        
        let sectionObject = CollectionViewSection.fromRaw(section)!

        switch sectionObject {
        case .Light:
            return lights.count
        case .Colour:
            return colours.count
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

        let width = realCollectionViewWidth;
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
    
    
    // MARK: DNZEmptyDataSetDataSource, DNZEmptyDataSetDelegate
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        let image = UIImage(named: "small-lightbulb")
        return image
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let titleString = "You haven't set up lights and colours 😢"
        let attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont.systemFontOfSize(15)
        ]
        
        let title = NSAttributedString(string: titleString, attributes: attributes)
        return title
    }

    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let titleString = "Tap the light to get started !"
        let attributes = [
            NSForegroundColorAttributeName: UIColor.lightGrayColor(),
            NSFontAttributeName: UIFont.systemFontOfSize(13)
        ]
        
        let descriptionTitle = NSAttributedString(string: titleString, attributes: attributes)
        return descriptionTitle
    }
    
    func emptyDataSetDidTapView(scrollView: UIScrollView!) {
        openCompanionApp()
    }
    
    func offsetForEmptyDataSet(scrollView: UIScrollView!) -> CGPoint {
        return CGPoint(x: 0, y: 20)
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
    

    // MARK: LFXNetworkContextObserver
    func networkContext(networkContext: LFXNetworkContext!, didAddTaggedLightCollection lifxCollection: LFXTaggedLightCollection!) {
        if let collection = lightForLifxCollection(lifxCollection) {
            collection.lifxCollection = lifxCollection
            updateView()
        }
    }
    
    func networkContext(networkContext: LFXNetworkContext!, didRemoveTaggedLightCollection lifxCollection: LFXTaggedLightCollection!) {
        if let collection = lightForLifxCollection(lifxCollection) {
            collection.lifxCollection = nil
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
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }

    
    // MARK: User interactions
    @IBAction func toogledSwitch(sender: UISwitch) {
        updateSelectedLightState()
        updateView()
    }
    

    // MARK: Convenience methods - Light related
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

    func lightForLifxLight(lifxLight: LFXLight) -> Light? {
        return lights.filter {
            return $0.deviceID == lifxLight.deviceID
        }.firstObject()
    }
    
    func lightForLifxCollection(lifxCollection: LFXTaggedLightCollection) -> Light? {
        return lights.filter {
            return $0.collectionTag == lifxCollection.tag
        }.firstObject()
    }
    
    func updateSelectedLightState() {
        if let powerState = LFXPowerState.fromRaw(UInt(toogleSwitch.on)) {
            selectedLight?.target?.setPowerState(powerState)
        }
    }
    
    
    // MARK: Convenience methods - Updating UI informations
    func updateView() {
        if (lights.isEmpty || colours.isEmpty) {
            collectionViewHeightConstraint.constant = kEmptyBulbsCollectionViewHeight
            toogleSwitch.hidden = true
        } else {
            updateCollectionViewHeight()
            toogleSwitch.hidden = false
            selectFirstLightIfNeeded()
            updateToogleFromSelectedLight()
        }
        collectionView.reloadData()
    }
    
    func updateCollectionViewHeight() {
        collectionViewHeightConstraint.constant = collectionView.contentSize.height
    }
    
    func selectFirstLightIfNeeded() {
        let hasOnlyOneLight = (lights.count == 1)
        let isFirstLightAvailable = (lights.firstObject()?.isAvailable)
        let shouldSelectFirstLight = (hasOnlyOneLight && isFirstLightAvailable? != nil && isFirstLightAvailable! == true)
        if shouldSelectFirstLight {
            selectedLightIndex = 0
        }
    }
    
    func updateToogleFromSelectedLight() {
        if let currentLight = selectedLight {
            if let lifxTarget = currentLight.target {
                switch lifxTarget.fuzzyPowerState() {
                case .On:
                    updateAvailableToogleWithStatus(isOn: true)
                case .Off:
                    updateAvailableToogleWithStatus(isOn: false)
                default:
                    break
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
    
    
    // MARK: Convenience methods - Others
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
            selectedLight.target?.setColor(selectedColour)
        }
    }
    
    func configureEmptyDataSet() {
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
    }
    
    func openCompanionApp() {
        let companionURL = NSURL(string: "LIFXWidgetCompanion://")
        extensionContext?.openURL(companionURL, completionHandler: nil)
    }


}
