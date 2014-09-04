//
//  ColourViewController.swift
//  LiFXWidget
//
//  Created by Maxime de Chalendar on 03/08/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import UIKit

class ColourViewController : UIViewController {
    
    // MARK: Properties
    var colour: LFXHSBKColor?
    @IBOutlet var colorPickerView: HRColorPickerView!
    
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        initColorPickerView()
    }
    
    
    // MARK: User interactions
    @IBAction func pressedDoneButton(sender: UIBarButtonItem) {
        saveSelectedColour()
        dismiss()
    }
    
    
    // MARK: Convenience methods
    func initColorPickerView() {
        colorPickerView.color = colour?.UIColor() ?? UIColor.randomColor()
    }
    
    func saveSelectedColour() {
        let selectedColour = colorPickerView.color
        let (hue, saturation, brightness, alpha) = selectedColour.HSBAComponents()

        let generatedColour = LFXHSBKColor(hue: hue * CGFloat(LFXHSBKColorMaxHue), saturation: saturation, brightness: brightness)
        if let colour = colour {
            SettingsPersistanceManager.updateColour(colour, withColour: generatedColour)
        } else {
            SettingsPersistanceManager.addColour(generatedColour)
        }
    }
    
    func dismiss() {
        navigationController?.popViewControllerAnimated(true)
    }
}
