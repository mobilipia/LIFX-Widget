//
//  LightCollectionViewCell.swift
//  LiFXWidget
//
//  Created by Maxime de Chalendar on 30/07/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import Foundation
import UIKit

class LightCollectionViewCell : CircleCollectionViewCell {
    // MARK: Properties
    // FIXME: Replace class func with class let when supported
    class func cellIdentifier() -> String { return "LightCollectionViewCell" }
    
    @IBOutlet var titleLabel: UILabel!

    
    // MARK: UIView
    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundColor = UIColor.lightGrayColor()
        titleLabel.textColor = UIColor.blackColor()
        onSelectionColour = UIColor.whiteColor()
    }
    
    
    // MARK: Public methods
    func configureWithLight(light: Light, isEnabled: Bool, isSelected: Bool) {
        titleLabel.text = light.friendlyName
        updateViewForEnabled(isEnabled, selected: isSelected)
    }
}