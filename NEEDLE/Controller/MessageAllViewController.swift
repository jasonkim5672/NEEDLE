//
//  MessageAllViewController.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 12. 16..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit

class MessageAllViewController: UIViewController {

    
    @IBOutlet weak var testButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var colors = [UIColor]()
        colors.append(UIColor(red: 136, green: 128, blue: 216))
        colors.append(UIColor(red: 91, green: 143, blue: 191))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        
        overaction()
        // Do any additional setup after loading the view.
    }
    
    func overaction() {
        
        testButton.setTitle(String(selectMessageItem), for: .normal)
        
        
        /*
        let alert = UIAlertController(title: "My Title", message: selectMessageItem, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
 */
        
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
