//
//  LightViewController.swift
//  LiFXWidget
//
//  Created by Maxime de Chalendar on 03/08/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import UIKit

class LightViewController : UIViewController {
    @IBOutlet var textField: UITextField!
    var light: Light?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = light?.friendlyName
        title = light?.friendlyName
    }

    @IBAction func pressedDoneButton(sender: UIBarButtonItem) {
        if let light = light {
            if textField.text.isEmpty == false {
                light.friendlyName = textField.text
                SettingsPersistanceManager.updateLight(light)
            }
        }
        navigationController.popViewControllerAnimated(true)
    }
}
