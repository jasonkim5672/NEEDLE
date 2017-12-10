//
//  EventPostView.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 12. 10..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit

class EventPostView: UIView {
    @IBOutlet var authorLabel : UILabel!
    @IBOutlet var profileImage : UIImageView!{
        didSet{
            profileImage.layer.cornerRadius = 5.0
            profileImage.layer.masksToBounds = true
        }
    }
    @IBOutlet var titleLabel : UILabel!{
        didSet {
            titleLabel.numberOfLines = 1
            
        }
    }
    @IBOutlet var thumbnailImage : UIImageView!
    @IBOutlet var summaryLabel : UILabel!{
        didSet {
            summaryLabel.numberOfLines = 1
            
        }
    }
    @IBOutlet var dateLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
     
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
