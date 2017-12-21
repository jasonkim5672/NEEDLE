//
//  ProfileHeaderView.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 12. 9..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {
    @IBOutlet var FollowLayer : UIView!{
        didSet{
        FollowLayer.layer.borderColor = UIColor(red:148,green:167,blue:232).cgColor
        FollowLayer.layer.borderWidth = 2
        FollowLayer.layer.cornerRadius = 10
            FollowLayer.clipsToBounds = true
            
        }
    }
    @IBOutlet var followButton : UIButton!{
        didSet{/*
            followButton.layer.borderWidth = 2
            followButton.layer.borderColor = UIColor(red:148,green:167,blue:232).cgColor
            followButton.layer.cornerRadius = 10
            followButton.clipsToBounds = true
 */
            followButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        }
    }
    @IBOutlet var messageButton : UIButton!
    @IBOutlet var messageLayer : UIView!{
        didSet{
            messageLayer.layer.borderColor = UIColor(red:255,green:112,blue:101).cgColor
            messageLayer.layer.borderWidth = 2
            messageLayer.layer.cornerRadius = 10
            messageLayer.clipsToBounds = true
        }
    }
    
    @IBOutlet var coverImage : UIImageView!{
        didSet{
            coverImage.image =  UIImage(named: "defaultCover")
        }
    }
    @IBOutlet var profileImage : UIImageView!{
        didSet{
            
            
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
