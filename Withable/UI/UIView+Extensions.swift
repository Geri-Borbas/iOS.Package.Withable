//
//  UIView+Extensions.swift
//  Withable
//
//  Created by Geri Borbás on 08/04/2022.
//  http://www.twitter.com/Geri_Borbas
//

import UIKit


extension UIView {
    
    static var spacer: UIView {
        UIView().with {
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentHuggingPriority(.required, for: .vertical)
        }
    }
    
    var withRedLines: Self {
        with {
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 2
            $0.layer.borderColor = UIColor.red.withAlphaComponent(0.6 * 0.5).cgColor
            $0.backgroundColor = UIColor.red.withAlphaComponent(0.2 * 0.5)
        }
    }
    
    var inspect: Self {
        withRedLines
    }
}


// MARK: Constraints

extension UIView {
    
    func pin(to: UILayoutGuide, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: to.topAnchor, constant: insets.top).isActive = true
        bottomAnchor.constraint(equalTo: to.bottomAnchor, constant: -insets.bottom).isActive = true
        leftAnchor.constraint(equalTo: to.leftAnchor, constant: insets.left).isActive = true
        rightAnchor.constraint(equalTo: to.rightAnchor, constant: -insets.right).isActive = true
    }
    
    func pin(to: UIView, insets: UIEdgeInsets = .zero) {
       translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: to.topAnchor, constant: insets.top).isActive = true
        bottomAnchor.constraint(equalTo: to.bottomAnchor, constant: -insets.bottom).isActive = true
        leftAnchor.constraint(equalTo: to.leftAnchor, constant: insets.left).isActive = true
        rightAnchor.constraint(equalTo: to.rightAnchor, constant: -insets.right).isActive = true
    }
    
    @discardableResult func top(to: UIView, inset: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        return topAnchor.constraint(equalTo: to.topAnchor, constant: inset).with {
            $0.isActive = true
        }
    }
    
    @discardableResult func centerX(to: UIView, inset: CGFloat = 0) -> NSLayoutConstraint {
       translatesAutoresizingMaskIntoConstraints = false
        return centerXAnchor.constraint(equalTo: to.centerXAnchor, constant: inset).with {
            $0.isActive = true
        }
    }
    
    @discardableResult func set(height: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        return heightAnchor.constraint(equalToConstant: height).with {
            $0.isActive = true
        }
    }
    
    @discardableResult func set(width: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        return widthAnchor.constraint(equalToConstant: width).with {
            $0.isActive = true
        }
    }
}


// MARK: - onMoveToSuperview

extension UIView {
    
    typealias ViewAction = (_ view: UIView) -> Void
    typealias ViewAndSuperviewAction = (_ view: UIView, _ superview: UIView) -> Void
    
    /// The `onMoveToSuperview` closure will be called once, right after this view called its
    /// `didMoveToSuperView()`. Suitable place to add constraints to this view instance.
    /// See https://developer.apple.com/documentation/uikit/uiview/1622512-updateconstraints
    @discardableResult func onMoveToSuperview(_ onMoveToSuperview: @escaping ViewAction) -> Self {
        self.onMoveToSuperview = onMoveToSuperview
        return self
    }
    
    @discardableResult func onMoveToSuperview(_ onMoveToSuperview: @escaping ViewAndSuperviewAction) -> Self {
        self.onMoveToSuperview = { view in
            guard let superview = self.superview else { return }
            onMoveToSuperview(self, superview)
        }
        return self
    }
}


// MARK: - Swizzle

extension UIView {
    
    static var notSwizzled = true
    
    struct Keys {
        static var viewAction: UInt8 = 0
    }
    
    /// The `onMoveToSuperview` closure will be called once, right after this view called its
    /// `didMoveToSuperView()`. Suitable place to add constraints to this view instance.
    /// See https://developer.apple.com/documentation/uikit/uiview/1622512-updateconstraints
    var onMoveToSuperview: ViewAction? {
        get {
            objc_getAssociatedObject(self, &Keys.viewAction) as? ViewAction
        }
        set {
            swizzleIfNeeded()
            objc_setAssociatedObject(self, &Keys.viewAction, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc fileprivate func originalDidMoveToSuperview() {
        // Original implementation will be copied here.
    }
    
    @objc fileprivate func swizzledDidMoveToSuperview() {
        originalDidMoveToSuperview()
        if superview != nil {
            onMoveToSuperview?(self)
            onMoveToSuperview = nil
        }
    }
    
    fileprivate func swizzleIfNeeded() {
        
        guard Self.notSwizzled else {
            return
        }
        
        guard let viewClass: AnyClass = object_getClass(self) else {
            return print("Could not get `UIView` class.")
        }
        
        let selector = #selector(didMoveToSuperview)
        guard let method = class_getInstanceMethod(viewClass, selector) else {
            return print("Could not get `didMoveToSuperview()` selector.")
        }
        
        let originalSelector = #selector(originalDidMoveToSuperview)
        guard let originalMethod = class_getInstanceMethod(viewClass, originalSelector) else {
            return print("Could not get original `originalDidMoveToSuperview()` selector.")
        }
        
        let swizzledSelector = #selector(swizzledDidMoveToSuperview)
        guard let swizzledMethod = class_getInstanceMethod(viewClass, swizzledSelector) else {
            return print("Could not get swizzled `swizzledDidMoveToSuperview()` selector.")
        }
        
        // Swap implementations.
        method_exchangeImplementations(method, originalMethod)
        method_exchangeImplementations(method, swizzledMethod)
        
        // Flag.
        Self.notSwizzled = false
    }
}
