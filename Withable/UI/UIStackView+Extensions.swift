//
//  UIStackView+Extensions.swift
//  Withable
//
//  Created by Geri Borbás on 08/04/2022.
//  http://www.twitter.com/Geri_Borbas
//

import UIKit


public extension UIStackView {
    
    func horizontal(spacing: CGFloat = 0) -> Self {
        with {
            $0.axis = .horizontal
            $0.spacing = spacing
        }
    }
    
    func vertical(spacing: CGFloat = 0) -> Self {
        with {
            $0.axis = .vertical
            $0.spacing = spacing
        }
    }
    
    func views(_ views: UIView ...) -> Self {
        views.forEach { self.addArrangedSubview($0) }
        return self
    }
}
