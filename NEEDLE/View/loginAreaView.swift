//
//  loginAreaView.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 12. 3..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit

class loginAreaView: UIView {
    @IBOutlet var userPhoto: UIImageView!{
        didSet{
            userPhoto.layer.cornerRadius = userPhoto.bounds.width / 2
            userPhoto.clipsToBounds = true
            
        }
        
    }
    @IBOutlet var userName: UILabel!
    @IBOutlet var userNumber: UILabel!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
