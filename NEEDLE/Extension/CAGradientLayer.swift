//
//  CAGradientLayer.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 11. 30..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import Foundation
import UIKit

extension CAGradientLayer {
    
    /*
     Needle color start 136.128.216
     Needle color end 91.143.191
     */
    
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0.3)
        endPoint = CGPoint(x: 0.6, y: 0)
    }
    
    func creatGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}
