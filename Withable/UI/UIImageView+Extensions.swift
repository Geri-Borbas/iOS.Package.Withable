//
//  UIImageView+Extensions.swift
//  Withable
//
//  Created by Geri Borbás on 30/03/2022.
//  http://www.twitter.com/Geri_Borbas
//

import UIKit


extension UIImageView {
    
    func with(image: UIImage?) -> Self {
        with {
            $0.image = image
        }
    }
}
