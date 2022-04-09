//
//  Withable.swift
//  Withable
//
//  Created by Geri Borbás on 28/11/2020.
//  http://www.twitter.com/Geri_Borbas
//

import Foundation


// MARK: - Withable for Objects

public protocol ObjectWithable: AnyObject {
    
    associatedtype T
    
    /// Provides a closure to configure instances inline.
    /// - Parameter closure: A closure `self` as the argument.
    /// - Returns: Simply returns the instance after called the `closure`.
    @discardableResult func with(_ closure: (_ instance: T) -> Void) -> T
}

public extension ObjectWithable {
    
    @discardableResult func with(_ closure: (_ instance: Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

extension NSObject: ObjectWithable { }


// MARK: - Withable for Values

public protocol Withable {
    
    associatedtype T
    
    /// Provides a closure to configure instances inline.
    /// - Parameter closure: A closure with a mutable copy of `self` as the argument.
    /// - Returns: Simply returns the mutated copy of the instance after called the `closure`.
    @discardableResult func with(_ closure: (_ instance: inout T) -> Void) -> T
}

public extension Withable {
    
    @discardableResult func with(_ closure: (_ instance: inout Self) -> Void) -> Self {
        var copy = self
        closure(&copy)
        return copy
    }
}
