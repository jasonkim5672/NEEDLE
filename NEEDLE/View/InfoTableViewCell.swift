//
//  InfoTableViewCell.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 12. 16..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    @IBOutlet var locationLabel : UILabel!
    @IBOutlet var dateLabel : UILabel!
    @IBOutlet var peopleLabel : UILabel!
    @IBOutlet var summaryLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
