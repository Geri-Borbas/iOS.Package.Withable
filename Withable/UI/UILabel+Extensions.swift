//
//  UILabel+Extensions.swift
//  Withable
//
//  Created by Geri Borbás on 08/04/2022.
//  http://www.twitter.com/Geri_Borbas
//

import UIKit


extension UILabel {
    
    func with(text: String?) -> Self {
        with {
            $0.text = text
        }
    }
}
