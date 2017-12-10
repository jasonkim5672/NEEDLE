//
//  EventPostCellTableViewCell.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 12. 9..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit

class EventPostCellTableViewCell: UITableViewCell {
    @IBOutlet var authorLabel : UILabel!
    @IBOutlet var profileImage : UIImageView!{
        didSet{
            profileImage.layer.cornerRadius = 5.0
            profileImage.layer.masksToBounds = true
        }
    }
    @IBOutlet var titleLabel : UILabel!
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
