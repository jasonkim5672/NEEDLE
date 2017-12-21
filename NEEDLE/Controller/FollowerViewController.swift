//
//  FollowerViewController.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 12. 16..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI
import CoreData

class FollowerViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,NSFetchedResultsControllerDelegate {
    var myEvents : [Event] = []
    
    @IBOutlet var table : UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myEvents.count
    }
    
    @IBOutlet weak var tableview: UITableView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        myEvents.sort(by: {
            if $0.registerTime > $1.registerTime{
                return true
            }
            return false
        })
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! EventPostCellTableViewCell
        
        cell.authorLabel.text = myEvents[indexPath.row].author
        cell.titleLabel.text = myEvents[indexPath.row].title
        cell.dateLabel.text = myEvents[indexPath.row].registerTime
        let url = myEvents[indexPath.row].thumbnailImage
        if ( url.count > 10) {
            let httpsReference = storage.reference(forURL: url)
            let imageView: UIImageView = cell.thumbnailImage
            let placeholderImage = UIImage(named: "LiveBeats")
            imageView.sd_setImage(with: httpsReference, placeholderImage: placeholderImage)
        }else{
            cell.thumbnailImage.image = UIImage(named: "LiveBeats")
        }
        //cell.profileImage.image = UIImage(named: "defaultUser")
        cell.profileImage.image = UIImage(named: "defaultUser")
        cell.summaryLabel.text = myEvents[indexPath.row].body
        
        
        return cell
    }
    
    var handler:DatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var colors = [UIColor]()
        colors.append(UIColor(red: 136, green: 128, blue: 216))
        colors.append(UIColor(red: 91, green: 143, blue: 191))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        // Fetch data from data store
        let helper = DispatchQueue.global()
        helper.sync {
            var EventHandler:DatabaseHandle!

            let rootRef = Database.database().reference()
            

            if let user = Auth.auth().currentUser {
                
                for i in NDFollowList{
                    EventHandler = rootRef.child("user-posts").child(user.uid).observe(DataEventType.value, with: { (userData) in
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
                                    let tmpEvent = Event(event.title! ,event.author!,event.body!,event.location!,event.period!,event.people,event.registerTime!,event.uid!,event.tag!,event.thumbnailImage!)
                                    var flag = true
                                    for d in self.myEvents{
                                        if (tmpEvent.title == d.title)&&(tmpEvent.registerTime == d.registerTime){
                                            flag = false
                                            break
                                        }
                                    }
                                    if flag == true{
                                    self.myEvents.append(tmpEvent)
                                    }
                                    print(row)
                                    
                                }
                            }
                        }
                        self.table.reloadData()
                        
                        
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    
                }
                
            }
            
        }
      
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
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
