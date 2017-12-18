//
//  ChatTableViewCell.swift
//  NEEDLE
//
//  Created by 양준혁 on 2017. 12. 17..
//  Copyright © 2017년 JasonKim. All rights reserved.
//
import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel! {
        didSet {
            nameLabel.numberOfLines = 0
        }
    }
    @IBOutlet var subLabel: UILabel! {
        didSet {
            subLabel.numberOfLines = 0
        }
    }
    
    /*
    @IBOutlet var typeLabel: UILabel! {
        didSet {
            typeLabel.numberOfLines = 0
        }
    }*/
    
    @IBOutlet var thumbnailImageView: UIImageView! {
        didSet {
            thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width / 2
            thumbnailImageView.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}



