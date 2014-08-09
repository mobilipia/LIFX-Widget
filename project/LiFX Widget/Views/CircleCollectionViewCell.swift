//
//  CircleCollectionViewCell.swift
//  LiFXWidget
//
//  Created by Maxime de Chalendar on 03/08/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import Foundation
import UIKit

class CircleCollectionViewCell : UICollectionViewCell {
    // MARK: Properties
    var onSelectionColour: UIColor = UIColor.lightGrayColor() {
    willSet {
        layer.borderColor = newValue.CGColor
    }
    }

    
    // MARK: UIView
    override func layoutSubviews() {
        super.layoutSubviews()

        assert(CGRectGetWidth(bounds) == CGRectGetHeight(bounds), "CircleCollectionViewCell must be squared")
        layer.cornerRadius = CGRectGetWidth(bounds) / 2.0
        layer.masksToBounds = true
        layer.borderColor = onSelectionColour.CGColor
    }
    
    
    // MARK: Public methods
    func updateViewForEnabled(enabled: Bool, selected: Bool) {
        alpha = (enabled ? 1 : 0.5)
        layer.borderWidth = (selected ? 1 : 0)
    }
}