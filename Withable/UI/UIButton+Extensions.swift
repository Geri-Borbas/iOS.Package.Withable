//
//  UIButton+Extensions.swift
//  Withable
//
//  Created by Geri Borbás on 30/03/2022.
//  http://www.twitter.com/Geri_Borbas
//

import UIKit


extension UIButton {
    
    typealias Action = () -> Void
    
    var onTap: Action? {
        get {
            associatedObject(for: "onTapAction") as? Action
        }
        set {
            set(associatedObject: newValue, for: "onTapAction")
        }
    }
    
    func onTap(_ action: @escaping Action) -> Self {
        self.onTap = action
        addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
        return self
    }
    
    @objc func didTouchUpInside() {
        onTap?()
    }
}
