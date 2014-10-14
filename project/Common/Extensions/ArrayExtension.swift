//
//  ArrayExtension.swift
//  LiFXWidget
//
//  Created by Maxime de Chalendar on 04/08/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

import Foundation

extension Array {
    func firstObject() -> T? {
        if self.isEmpty {
            return nil
        } else {
            return self[0]
        }
    }
    
    mutating func remove<T: Equatable>(toRemove: T) {
        for (idx, element) in enumerate(self) {
            if let sameTypeElement = element as? T {
                if sameTypeElement == toRemove {
                    self.removeAtIndex(idx)
                    break
                }
            }
        }
    }
    
    mutating func moveObjectAtIndex(oldIndex: Int, toIndex newIndex: Int) {
        let objectToMove = self[oldIndex]
        self.removeAtIndex(oldIndex)
        self.insert(objectToMove, atIndex: newIndex)
    }

}
