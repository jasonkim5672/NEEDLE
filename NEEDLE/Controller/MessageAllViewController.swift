//
//  MessageAllViewController.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 12. 16..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit
import Firebase

class MessageAllViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var myChatRoom : [ChatRoom] = []
    var findChatType : Int = 0
    
    @IBOutlet weak var chatListView: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
        
        if tableView == self.chatListView {
            count = myChatRoom.count
        } else {
            count = 0
        }
        return count!
        
    }

    func removeUser(_ crId:String) {
        for vChat in myChatRoom {
            if vChat.uid == crId {
                var i=0
                for vUser in vChat.user {
                    if vUser == chatUserId {
                        vChat.user.remove(at: i)
                        break
                    }
                    i = i + 1
                }
                
                i=0
                for vUser in vChat.user {
                    if vUser == chatUserId {
                        vChat.user.remove(at: i)
                        break
                    }
                    i = i + 1
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //array.remove(at: indexPath.row)
            //tableView.deleteRows(at: [indexPath], with: .fade)
            let refUpdate = Database.database().reference().child("chats/room/" + myChatRoom[indexPath.row].uid)
            removeUser(myChatRoom[indexPath.row].uid)
            refUpdate.updateChildValues(["user": myChatRoom[indexPath.row].user])
        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChatTableViewCell
        
        cell.nameLabel.text = myChatRoom[indexPath.row].name
        cell.subLabel.text = myChatRoom[indexPath.row].sub
        cell.thumbnailImageView.image = UIImage(named: "defaultUser")
        
        //if let restaurantImage = restaurants[indexPath.row].image { cell.thumbnailImageView.image = UIImage(data: restaurantImage)
        //}
        
        return cell
        
            /*
     
     var cell:UITableViewCell?
     
     if tableView == self.chatListView {
     let cell:ChatTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatTableViewCell
     cell.nameLabel.text = "Hello"
     } else {
     cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) //as! ChatTableViewCell
     }
     return cell! */
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChatDetail" {
            if let indexPath = chatListView.indexPathForSelectedRow {
                let destinationController = segue.destination as! ChatViewController
                destinationController.myChat = myChatRoom[indexPath.row]
                
            }
        }
        if let indexPath = chatListView.indexPathForSelectedRow {
            chatListView.deselectRow(at: indexPath, animated: false)
        }
        
    }
    
    @IBOutlet weak var testButton: UIButton!
    override func viewWillAppear(_ animated: Bool) {
       //loginCheck()
        
        if(drawFinsh==true)
        {
            loginCheck()
        }
        
        //chatListView.delegate = self
        //chatListView.dataSource = self
    }
    
    func newRoom(_ updateChatRoom:ChatRoom){
        
        var allowInsert:Bool = false
        for followUser in updateChatRoom.user {
            if followUser == chatUserId {
                allowInsert = true
            }
        }
        
        if allowInsert == true {
            allowInsert = false
            if(self.findChatType == 0){
                allowInsert = true
            }
            if(self.findChatType == 1 && updateChatRoom.type == "1") {
                allowInsert = true
            }
            if(self.findChatType == 2 && updateChatRoom.type == "2") {
                allowInsert = true
            }
            
            if allowInsert == true {
                
                if(needMessageShow == true) {
                    self.alertFunc(updateChatRoom.sub,"[새쪽지] " + updateChatRoom.name)
                }
                self.myChatRoom.insert(updateChatRoom, at: 0)
                self.chatListView.reloadData()
            }
        }
    }
    
    
    func findChatRoom()
    {
        //print(chatUserName)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        if(oldChatUserId != chatUserId && chatUserId != "0") {
            
        let ref = Database.database().reference()
         ref.child("chats").child("room").observe(.childAdded, with: { (snapshot) in
            var fItem = snapshot.value as! [String:AnyObject]
            let updateChatRoom = ChatRoom()
            
            updateChatRoom.uid = snapshot.key
            updateChatRoom.name = fItem["name"] as? String ?? "제목없음"
            updateChatRoom.sub = fItem["sub"] as? String ?? "내용없음"
            updateChatRoom.type = fItem["type"] as? String ?? "2"
            updateChatRoom.user = fItem["user"] as? [String] ?? [""]
            
            self.newRoom(updateChatRoom)
            /*
             if let followUser = fItem["user"] as? [String] {
             for ffUsr in followUser {
             if(ffUsr == chatUserId)
             {
             
             
             }
             }
             }*/
            
        })
        
        ref.child("chats").child("room").observe(.childChanged, with: { (snapshot) in
            var fItem = snapshot.value as! [String:AnyObject]
            
            /* 최적화
            var findSS : Bool = false
            for updateChatRoom in self.myChatRoom {
                if updateChatRoom.uid == snapshot.key {
                    findSS = true
                    updateChatRoom.uid = snapshot.key
                    updateChatRoom.name = fItem["name"] as? String ?? "제목없음"
                    updateChatRoom.sub = fItem["sub"] as? String ?? "내용없음"
                    updateChatRoom.type = fItem["type"] as? String ?? "0"
                    updateChatRoom.user = fItem["user"] as? [String] ?? [""]
                    
                    var hasUser:Bool = false
                    for followUser in updateChatRoom.user {
                        if followUser == chatUserId {
                            hasUser = true
                        }
                    }
                    if hasUser == false {
                        self.removeRoom(snapshot.key)
                    }
                    
                }
            } */
            self.removeRoom(snapshot.key)
            let updateChatRoom = ChatRoom()
            updateChatRoom.uid = snapshot.key
            updateChatRoom.name = fItem["name"] as? String ?? "제목없음"
            updateChatRoom.sub = fItem["sub"] as? String ?? "내용없음"
            updateChatRoom.type = fItem["type"] as? String ?? "2"
            updateChatRoom.user = fItem["user"] as? [String] ?? [""]
            self.newRoom(updateChatRoom)
        })
        
        ref.child("chats").child("room").observe(.childRemoved, with: { (snapshot) in
            self.removeRoom(snapshot.key)
            //self.myChatRoom.append(newChatRoom)
        })
        
        
        }
        
        
        //if let dictionary = snapshot.value as? [String:Any] {
        //    print(dictionary)
        //guard let dictionary = snapshot.value as? [String: Any] else {
        //    return
        // }
        
        // guard let statusDictionary = dictionary["status"] as? [String: Any] else {
        //     return
        // }
        
        //guard let deviceStatusDictionary = statusDictionary["DEVICE_KEY"] as? [String: Any] else {
        //    return
        //}
        
        //var newChat = ChatRoom()
        //newChat.uid =  deviceStatusDictionary["isconnected"] as? String
        
        //self.myChatRoom.append(newChat)
        //}
        
        
       // self.chatListView.reloadData()
        
        
        /*
        if let user = Auth.auth().currentUser {
            rootRef.child("chats/room").observeSingleEvent(of: .value, with: { (userData) in
                // Get user value
                if let Data = userData.value as? NSDictionary{
                    for row in Data as! [String:NSDictionary] {
                        
                        self.myChatRoom.append(ChatRoom.init(uid: row.uid as? String ?? " ",name : row.value["name"] as? String ?? " ", sub : user.uid, location: row.value["location"] as? String ?? " " ))
                        
                    }
                }
                //self.tableView.reloadData()
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
        } */
    }
    
    
    func removeRoom(_ iUid:String) {
        var i = 0
        for updateChatRoom in self.myChatRoom {
            if updateChatRoom.uid == iUid {
                self.myChatRoom.remove(at: i)
                self.chatListView.reloadData()
                break
            }
            i = i + 1
        }
    }
    
    var drawFinsh:Bool = false
    
    override func viewDidLoad() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        findChatType = selectMessageItem //보고있는 페이지 찾기
        
        super.viewDidLoad()
        var colors = [UIColor]()
        colors.append(UIColor(red: 136, green: 128, blue: 216))
        colors.append(UIColor(red: 91, green: 143, blue: 191))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        //overaction()
        
        
        chatListView.delegate = self
        chatListView.dataSource = self
        
        //myChatRoom.removeAll()
        loginCheck()
        drawFinsh = true
        
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

    
    var oldChatUserId = ""
    var liveOb : Bool = false
    
    func loginCheck() {
        if let user = Auth.auth().currentUser {
           
            let rootRef = Database.database().reference()
            rootRef.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (userData) in
                
                let value = userData.value as? NSDictionary
                let username = value?["username"] as? String ?? ""
                
                //chatUserId = user.uid
                //chatUserName = username
                //self.alertFunc(username)
                
                if(self.oldChatUserId != user.uid)
                {
                    self.chatListView.delegate = nil
                    self.chatListView.dataSource = nil
                    self.myChatRoom.removeAll()
                    self.chatListView.delegate = self
                    self.chatListView.dataSource = self
                    
                    print(self.oldChatUserId + "   " + chatUserId)
                    chatUserId = user.uid
                    chatUserName = username
                    self.findChatRoom()
                    self.oldChatUserId = chatUserId
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
          
        }else{
            
            chatListView.delegate = nil
            chatListView.dataSource = nil
            self.myChatRoom.removeAll()
            chatListView.delegate = self
            chatListView.dataSource = self
            
            //ref.removeAllObservers()
            //liveOb = false
            
            alertFunc("로그인이 필요합니다.", "권한경고")
            chatUserId = "0"
            chatUserName = "비회원"
        }
    }
    
    
}
