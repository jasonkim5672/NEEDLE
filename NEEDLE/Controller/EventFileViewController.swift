//
//  EventFileViewController.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 12. 16..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit

class EventFileViewController: UIViewController {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var thisEvent : Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var colors = [UIColor]()
        colors.append(UIColor(red: 136, green: 128, blue: 216))
        colors.append(UIColor(red: 91, green: 143, blue: 191))
        
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        nameLabel.text = thisEvent.title
        
       
        let url = thisEvent.thumbnailImage
        if (url != nil && url != "") {
            let httpsReference = storage.reference(forURL: url)
            let imageView: UIImageView = coverImage
            let placeholderImage = UIImage(named: "LiveBeats")
            imageView.sd_setImage(with: httpsReference, placeholderImage: placeholderImage)
        }else{
            coverImage.image = UIImage(named: "LiveBeats")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
