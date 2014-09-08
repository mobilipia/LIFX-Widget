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
    var onColourSelection: ((initialColour: LFXHSBKColor?, newColour: LFXHSBKColor) -> ())?
    @IBOutlet var colorPickerView: HRColorPickerView!
    
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        configureColorPickerView()
    }
    
    
    // MARK: User interactions
    @IBAction func pressedDoneButton(sender: UIBarButtonItem) {
        let selectedColour = colorPickerView.color
        let (hue, saturation, brightness, alpha) = selectedColour.HSBAComponents()
        
        let generatedColour = LFXHSBKColor(hue: hue * CGFloat(LFXHSBKColorMaxHue), saturation: saturation, brightness: brightness)
        onColourSelection?(initialColour: colour, newColour: generatedColour)
    }
    
    // MARK: Convenience methods
    func configureColorPickerView() {
        colorPickerView.color = colour?.UIColor() ?? UIColor.randomColor()
    }
    
}
