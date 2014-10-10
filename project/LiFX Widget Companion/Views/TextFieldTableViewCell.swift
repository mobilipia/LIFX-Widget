//
//  LifxTargetTableViewCell.swift
//  LiFX Widget
//
//  Created by Maxime de Chalendar on 9/6/14.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import Foundation

class LifxTargetTableViewCell : UITableViewCell {
    @IBOutlet var textField: UITextField!
    @IBOutlet var typeLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.typeLabel.layer.cornerRadius = 6
        self.typeLabel.layer.masksToBounds = true
    }

    func configureWithLight(light: Light) {
        textField.placeholder = light.friendlyName
        textField.text = light.friendlyName
        
        typeLabel.text = ((light.deviceID != nil) ? "Light" : "Collection")
    }
}