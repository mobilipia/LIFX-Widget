//
//  ColourCollectionViewCell.swift
//  LiFXWidget
//
//  Created by Maxime de Chalendar on 29/07/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import Foundation
import UIKit

class ColourCollectionViewCell : CircleCollectionViewCell {
    // MARK: Properties
    // FIXME: Replace class func with class let when supported
    class func cellIdentifier() -> String { return "ColourCollectionViewCell" }
    

    // MARK: Public methods
    func configureWithColour(colour: UIColor, isEnabled: Bool, isSelected: Bool) {
        backgroundColor = colour
        updateViewForEnabled(isEnabled, selected: isSelected)
    }
}