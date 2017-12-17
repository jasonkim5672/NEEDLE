//
//  MessageAllViewController.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 12. 16..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit
import Firebase

class MessageAllViewController: UIViewController {
    
    @IBOutlet weak var testButton: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        loginCheck()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var colors = [UIColor]()
        colors.append(UIColor(red: 136, green: 128, blue: 216))
        colors.append(UIColor(red: 91, green: 143, blue: 191))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        //overaction()
    }
        
    func alertFunc(_ memo:String, _ title:String="경고") {
        let alert = UIAlertController(title: title, message: memo, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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

    
    
    
    func loginCheck() {
        if let user = Auth.auth().currentUser {
           
            let rootRef = Database.database().reference()
            rootRef.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (userData) in
                
                let value = userData.value as? NSDictionary
                let username = value?["username"] as? String ?? ""
                chatUserId = user.uid
                chatUserName = username
                
            }) { (error) in
                print(error.localizedDescription)
            }
          
        }else{
          //alertFunc("로그인이 필요합니다.", "권한경고")
          chatUserId = "0"
          chatUserName = "비회원"
        }
    }
    
    
}
