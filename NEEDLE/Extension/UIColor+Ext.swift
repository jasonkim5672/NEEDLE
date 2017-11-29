//
//  UIColor+Ext.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 11. 30..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let redValue = CGFloat(red) / 255.0
        let greenValue = CGFloat(green) / 255.0
        let blueValue = CGFloat(blue) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue,
                  alpha: 1.0) }
}
