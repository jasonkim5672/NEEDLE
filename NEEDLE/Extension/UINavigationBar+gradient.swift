//
//  UINavigationBar+gradient.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 11. 30..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    
    func setGradientBackground(colors: [UIColor]) {
        
        var updatedFrame = bounds
        updatedFrame.size.height += 20
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        
        setBackgroundImage(gradientLayer.creatGradientImage(), for: UIBarMetrics.default)
    }
}
