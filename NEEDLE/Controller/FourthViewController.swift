//
//  FourthViewController.swift
//  niddle
//
//  Created by Jason Kim on 2017. 11. 29..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit
import Firebase

class FourthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var colors = [UIColor]()
        colors.append(UIColor(red: 136, green: 128, blue: 216))
        colors.append(UIColor(red: 91, green: 143, blue: 191))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        // Do any additional setup after loading the view.
        /*포스팅 부분 */
        let rootRef = Database.database().reference()
        let key = rootRef.child("posts").childByAutoId().key
        if let user = Auth.auth().currentUser {

        let post = ["uid": user.uid,
                    "author": "김병우",
                    "title": "모바일프로그래밍 실습!",
                    "body": "Swift 짱짱맨",
                    "registerTime":"2017/12/11/12:30",
                    "location":"숭실대학교 정보과학관",
                    "period":"2017/12/21",
                    "tag":"학술",
                    "thumbnailimage":"",
                    ]
        let childUpdates = ["/posts/\(key)": post,
                            "/user-posts/\(user.uid)/\(key)/": post]
        rootRef.updateChildValues(childUpdates)
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
