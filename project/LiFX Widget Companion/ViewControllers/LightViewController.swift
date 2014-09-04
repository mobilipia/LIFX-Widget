//
//  LightViewController.swift
//  LiFXWidget
//
//  Created by Maxime de Chalendar on 03/08/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import UIKit

class LightViewController : UIViewController {
    
    // MARK: Properties
    @IBOutlet var textField: UITextField!
    var light: Light?
    
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    
    // MARK: User interactions
    @IBAction func pressedDoneButton(sender: UIBarButtonItem) {
        updateLightName()
        dismiss()
    }
    
    
    // MARK: Convenience methods
    func configureView() {
        let lightName = light?.friendlyName
        textField.text = lightName
        title = lightName
    }
    
    func updateLightName() {
        if let light = light {
            if textField.text.isEmpty == false {
                light.friendlyName = textField.text
                SettingsPersistanceManager.updateLight(light)
            }
        }
    }
    
    func dismiss() {
        navigationController?.popViewControllerAnimated(true)
    }
}
