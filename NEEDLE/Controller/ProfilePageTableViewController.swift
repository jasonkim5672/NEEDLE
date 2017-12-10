//
//  ProfilePageControllerTableViewController.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 12. 9..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit
import Firebase

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
            rootRef.child("user-posts").child(user.uid).observeSingleEvent(of: .value, with: { (userData) in
                // Get user value
                if let Data = userData.value as? NSDictionary{
                    for row in Data as! [String:NSDictionary] {
                        self.myEvents.append(Event.init(title: row.value["title"] as? String ?? " ",author : row.value["author"] as? String ?? " ", uid : user.uid, location: row.value["location"] as? String ?? " " , period : row.value["period"] as? String ?? " ",registerTime: row.value["registerTime"] as? String ?? " ",body : row.value["body"] as? String ?? " ",tag : row.value["tag"] as? String ?? " "))
                        print(row)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Timeline", for: indexPath) as! EventPostCellTableViewCell
        cell.authorLabel.text = myEvents[indexPath.row].author
        cell.titleLabel.text = myEvents[indexPath.row].title
        cell.dateLabel.text = myEvents[indexPath.row].registerTime
        cell.thumbnailImage.image = UIImage(named: "LiveBeats")
        //cell.profileImage.image = UIImage(named: "defaultUser")
        cell.profileImage.image = UIImage(named: "BW")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
