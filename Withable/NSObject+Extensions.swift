//
//  NSObject+Extensions.swift
//  Withable
//
//  Created by Geri Borbás on 08/04/2022.
//  http://www.twitter.com/Geri_Borbas
//

import Foundation


extension NSObject {
    
    struct Keys {
        static var associatedObjects: UInt8 = 0
    }
    
    var associatedObjects: NSMutableDictionary {
        get {
            if let associatedObjects = objc_getAssociatedObject(self, &Keys.associatedObjects) as? NSMutableDictionary {
                return associatedObjects
            } else {
                let associatedObjects: NSMutableDictionary = [:]
                objc_setAssociatedObject(self, &Keys.associatedObjects, associatedObjects, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return associatedObjects
            }
        }
    }
    
    public func set(associatedObject: Any?, for key: AnyHashable) {
        if let associatedObject = associatedObject {
            associatedObjects[key] = associatedObject
        } else {
            remove(associatedObjectFor: key)
        }
    }
    
    public func associatedObject(for key: AnyHashable) -> Any? {
        associatedObjects[key]
    }
    
    func remove(associatedObjectFor key: AnyHashable) {
        associatedObjects.removeObject(forKey: key)
    }
}
