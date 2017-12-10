//
//  ProfileHeaderView.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 12. 9..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {

    @IBOutlet var coverImage : UIImageView!{
        didSet{
            coverImage.image =  UIImage(named: "defaultCover")
        }
    }
    @IBOutlet var profileImage : UIImageView!{
        didSet{
            profileImage.layer.cornerRadius = 5.0
            profileImage.layer.masksToBounds = true
        }
    }
    @IBOutlet var name : UILabel!{
        didSet {
            name.numberOfLines = 0
            
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
