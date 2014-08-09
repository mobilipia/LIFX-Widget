//
//  LFXLightExtension.swift
//  LiFXWidget
//
//  Created by Maxime de Chalendar on 07/08/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import Foundation

extension LFXLight: Equatable {
}

// MARK: Equatable
public func == (lhs: LFXLight, rhs: LFXLight) -> Bool {
    return lhs.deviceID == rhs.deviceID
}