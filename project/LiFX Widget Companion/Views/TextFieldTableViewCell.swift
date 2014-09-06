//
//  TextFieldTableViewCell.swift
//  LiFX Widget
//
//  Created by Maxime de Chalendar on 9/6/14.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import Foundation

class TextFieldTableViewCell : UITableViewCell {
    @IBOutlet var textField: UITextField!

    func configureWithLight(light: Light) {
        textField.placeholder = light.friendlyName
        textField.text = light.friendlyName
    }
}