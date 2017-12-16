//
//  File.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 12. 17..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit
import Foundation

extension UITextField {
    
    func addBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height-height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
