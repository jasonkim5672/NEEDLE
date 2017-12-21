//
//  ProfilePageControllerTableViewController.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 12. 9..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI

class ProfilePageTableViewController: UITableViewController {
    var myEvents : [Event] = []
    @IBOutlet var profileHeaderView : ProfileHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        var colors = [UIColor]()
        colors.append(UIColor(red: 136, green: 128, blue: 216))
        colors.append(UIColor(red: 91, green: 143, blue: 191))
        
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        //    init(title: String, author: String, uid: String, location: String, period: String, registerTime: String, body: String, tag: String) {
        
        let rootRef = Database.database().reference()
        
        if let user = Auth.auth().currentUser {
            rootRef.child("users").child(profileUserId).observeSingleEvent(of: .value, with: { (userData) in
                // Get user value
                let value = userData.value as? NSDictionary
                self.profileHeaderView.name.text = value?["username"] as? String ?? ""
                
                
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
        
        
        
        if let user = Auth.auth().currentUser {
            /*
             if let photoURL = user.photoURL{
             let imageView: UIImageView = profileHeaderView.profileImage
             let placeholderImage = UIImage(named: "defaultUser")
             imageView.sd_setImage(with: photoURL, placeholderImage: placeholderImage)
             imageView.layer.cornerRadius = 50
             imageView.clipsToBounds = true
             }else{
             profileHeaderView.profileImage.image = UIImage(named: "defaultUser")
             }*/
            
            
            rootRef.child("users").child(profileUserId).observeSingleEvent(of: .value, with: { (userData) in
                /*
                if let Data = userData.value as? NSDictionary{
                    for row in Data as! [String:NSDictionary] {
                        self.profileHeaderView.name.text = row.value["username"] as? String ?? " "
                    }
                }*/
                /*
                 if let Data = userData.value as? [String:[String]]{
                 print(Data)
                 if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                 
                 self.profileHeaderView.name.text = Data["username"] as? String ?? ""
                 
                 
                 
                 }*/
                
                
            })
            
            
            
            
            
            //user.uid
            rootRef.child("user-posts").child(profileUserId).observeSingleEvent(of: .value, with: { (userData) in
                // Get user value
                if let Data = userData.value as? NSDictionary{
                    for row in Data as! [String:NSDictionary] {
                        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                            var event = MyEventMO(context: appDelegate.persistentContainer.viewContext)
                            let todaysDate:Date = Date()
                            let dateFormatter:DateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
                            let today :String = dateFormatter.string(from:todaysDate)
                            event.title = row.value["title"] as? String ?? " "
                            event.author = row.value["author"] as? String ?? " "
                            event.uid = row.value["uid"] as? String ?? " "
                            event.location = row.value["location"] as? String ?? " "
                            event.period = row.value["period"] as? String ?? today
                            event.registerTime = row.value["registerTime"] as? String ?? " "
                            event.body = row.value["body"] as? String ?? " "
                            event.tag = row.value["tag"] as? String ?? " "
                            event.people = row.value["people"] as? Int16 ?? 100
                            event.thumbnailImage = row.value["thumbnailImage"] as? String ?? " "
                            self.myEvents.append(Event(event.title! ,event.author!,event.body!,event.location!,event.period!,event.people,event.registerTime!,event.uid!,event.tag!,event.thumbnailImage!))
                            print(row)
                            
                        }
                    }
                }
                
                
                
                self.tableView.reloadData()
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
            //  print(self.myEvents)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myEvents.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        myEvents.sort(by: {
            if $0.registerTime > $1.registerTime{
                return true
            }
            return false
        })
        let cell = tableView.dequeueReusableCell(withIdentifier: "Timeline", for: indexPath) as! EventPostCellTableViewCell
        cell.authorLabel.text = myEvents[indexPath.row].author
        cell.titleLabel.text = myEvents[indexPath.row].title
        cell.dateLabel.text = myEvents[indexPath.row].registerTime
        let url = myEvents[indexPath.row].thumbnailImage ?? ""
        if (url != nil && url.count > 10 ) {
            let httpsReference = storage.reference(forURL: url)
            let imageView: UIImageView = cell.thumbnailImage
            let placeholderImage = UIImage(named: "LiveBeats")
            imageView.sd_setImage(with: httpsReference, placeholderImage: placeholderImage)
        }else{
            cell.thumbnailImage.image = UIImage(named: "LiveBeats")
        }
        if let user = Auth.auth().currentUser {
            
            if let photoURL = user.photoURL{
                let imageView: UIImageView = cell.profileImage
                let placeholderImage = UIImage(named: "defaultUser")
                imageView.sd_setImage(with: photoURL, placeholderImage: placeholderImage)
                imageView.layer.cornerRadius = 25
                imageView.clipsToBounds = true
            }else{
                cell.profileImage.image = UIImage(named: "defaultUser")
            }
            
        }
        
        cell.summaryLabel.text = myEvents[indexPath.row].body
        
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEvent" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let tabBarController = segue.destination as! EventPageTabBarController
                //let tmp = Event(title: myEvents[indexPath.row].title!, author: myEvents[indexPath.row].author!, uid: myEvents[indexPath.row].uid!, location: myEvents[indexPath.row].location!, period: myEvents[indexPath.row].period!, registerTime: myEvents[indexPath.row].registerTime!, body: myEvents[indexPath.row].body!, tag: myEvents[indexPath.row].tag!, people: myEvents[indexPath.row].people,thumbnailImage :myEvents[indexPath.row].thumbnailImage! )
                let destinationController0 = tabBarController.viewControllers?[0] as! EventInfoViewController
                let destinationController1 = tabBarController.viewControllers?[1] as! EventFeedViewController
                let destinationController2 = tabBarController.viewControllers?[2] as! EventPhotoViewController
                let destinationController3 = tabBarController.viewControllers?[3] as! EventFileViewController
                let destinationController4 = tabBarController.viewControllers?[4] as! EventQAViewController
                //destinationController.coverImage.image =  UIImage(named: "LiveBeats")
                destinationController0.thisEvent = myEvents[indexPath.row]
                destinationController1.thisEvent = myEvents[indexPath.row]
                destinationController2.thisEvent = myEvents[indexPath.row]
                destinationController3.thisEvent = myEvents[indexPath.row]
                destinationController4.thisEvent = myEvents[indexPath.row]
            }
        }
        
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
