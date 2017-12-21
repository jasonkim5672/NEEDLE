//
//  EventPageViewController.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 12. 16..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit
import Firebase

class EventInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var thisEvent : Event!
    
    @IBAction func chatChat(_ sender: Any) {
        
        
        let rootRef = Database.database().reference()
        
        if let user = Auth.auth().currentUser {
            rootRef.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (userData) in
                
                rootRef.child("/chats/room/\(self.thisEvent.uid)").setValue(["type":"2","name":self.thisEvent.title+" (1:1대화)", "sub":"새로운 대화를 시작합니다.", "user": [(user.uid), self.thisEvent.uid] ])
                
            })
            
        }
        
    }
    @IBAction func Share(_ sender: Any) {
       
    }
    @IBOutlet weak var chatUser: UIButton!
    @IBAction func joinEvent(_ sender: Any) {
        
        let rootRef = Database.database().reference()
       
        if let user = Auth.auth().currentUser {
            rootRef.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (userData) in
                
                rootRef.child("/chats/room/\(self.thisEvent.title)/user/").setValue( [(user.uid) ])
                
            })
            
        }
        
    }
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventLocation", for: indexPath) as! InfoTableViewCell
        cell.locationLabel.text = thisEvent.location
        cell.dateLabel.text = thisEvent.period
        cell.peopleLabel.text = String(thisEvent.people)
        cell.summaryLabel.text = thisEvent.body
        
        
        
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
