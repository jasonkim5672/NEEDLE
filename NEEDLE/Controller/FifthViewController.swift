//
//  FifthViewController.swift
//  niddle
//
//  Created by Jason Kim on 2017. 11. 29..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit
import Firebase

class FifthViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var loginArea: loginAreaView!
    @IBOutlet weak var backgroundLayer: UIView!
    @IBOutlet var logOutButton : UIButton!
    @IBAction func showLoginScreen(segue: UIStoryboardSegue){
        
    }
    @IBAction func back(segue: UIStoryboardSegue){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logIn(segue: UIStoryboardSegue){
        let rootRef = Database.database().reference()
        
        Auth.auth().signIn(withEmail: "supopopo@naver.com", password: "930204") { (user, error) in
            if user != nil{
                print("login success")
                if let user = Auth.auth().currentUser {
                    rootRef.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (userData) in
                        // Get user value
                        let value = userData.value as? NSDictionary
                        let username = value?["username"] as? String ?? ""
                        self.loginArea.userName.setTitle(username + " 님",for: .normal)
                        self.loginArea.userNumber.text = user.email
                        
                        // ...
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    if let photoURL = user.photoURL{
                        self.loginArea.userPhoto.image = UIImage(named: String(describing:photoURL))
                    }else{
                        self.loginArea.userPhoto.image = UIImage(named: "BW")
                    }
                    self.loginArea.isUserInteractionEnabled=false
                    self.logOutButton.isHidden=false
                    
                }
            }
            else{
                print("login fail")
            }
        }
        
    }
    
    @IBAction func logOut(segue: UIStoryboardSegue){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            loginArea.userPhoto.image = UIImage(named: "defaultUser")
            loginArea.userName.setTitle("로그인이 필요합니다.",for: .normal)
            loginArea.userNumber.text = "비회원번호 : 33709522"
            logOutButton.isHidden=true
            loginArea.isUserInteractionEnabled=true
            let alert = UIAlertController(title: "", message: "로그아웃 되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil ))
            self.present(alert, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
    }
    let menuList = ["마이페이지","구독목록", "정보수정", "설정", "고객센터"]
    let gradientLayer = CAGradientLayer()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menu", for: indexPath) as! menuListCell
        cell.menuLabel.text = menuList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath){
        if indexPath.row == 0 {
            
        }
        
    }
    
    
    var value : NSDictionary?
    var username : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //gradientLayer.frame =  loginArea.frame //(화면에서 좀 짤림 ... )
        gradientLayer.frame =  CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width, height: loginArea.bounds.size.height)
        
        let color1 = UIColor(red: 136, green: 128, blue: 216).cgColor
        let color2 = UIColor(red: 91, green: 143, blue: 191).cgColor
        gradientLayer.colors = [color1, color2]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.3)
        gradientLayer.endPoint = CGPoint(x: 0.6, y: 0)
        gradientLayer.locations = [0.0, 1.0]
        
        
        backgroundLayer.layer.addSublayer(gradientLayer)
        navigationController?.navigationBar.isHidden=true
        
        
    
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let user = Auth.auth().currentUser {
            if let photoURL = user.photoURL{
                let imageView: UIImageView = loginArea.userPhoto
                let placeholderImage = UIImage(named: "defaultUser")
                imageView.sd_setImage(with: photoURL, placeholderImage: placeholderImage)
            }else{
                loginArea.userPhoto.image = UIImage(named: "defaultUser")
            }
            let rootRef = Database.database().reference()

            rootRef.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (userData) in
                // Get user value
                let value = userData.value as? NSDictionary
                let username = value?["username"] as? String ?? ""
                self.loginArea.userName.setTitle(username + " 님",for: .normal)
            }) { (error) in
                self.loginArea.userName.setTitle(" ",for: .normal)
                print(error.localizedDescription)
             }
            self.loginArea.userNumber.text = user.email
            loginArea.isUserInteractionEnabled=false
            logOutButton.isHidden=false
            
        }else{
            loginArea.userPhoto.image = UIImage(named: "defaultUser")
            loginArea.userName.setTitle("로그인이 필요합니다.",for: .normal)
            loginArea.userNumber.text = "비회원번호 : 33709522"
            loginArea.isUserInteractionEnabled=true
            logOutButton.isHidden=true
            
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMyProfile" {
            let destinationController = segue.destination as! ProfilePageTableViewController
            let rootRef = Database.database().reference()
            if let user = Auth.auth().currentUser {
              
                
                rootRef.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (userData) in
                    // Get user value
                    let Data = userData.value as? NSDictionary
                    let coverImage = Data?["coverImage"] as? String ?? " "
                    if (coverImage==" "){
                        //destinationController.profileHeaderView.coverImage.image = UIImage(named: "defaultCover")
                        destinationController.profileHeaderView.coverImage.image = UIImage(named: "bwCover")

                    }else{
                        destinationController.profileHeaderView.coverImage.image = UIImage(named: String(describing:coverImage))

                    }
                    if let photoURL = user.photoURL{
                        destinationController.profileHeaderView.profileImage.image = UIImage(named: String(describing:photoURL))
                    }else{
                        //destinationController.profileHeaderView.profileImage.image = UIImage(named: "defaultUser")
                        destinationController.profileHeaderView.profileImage.image = UIImage(named: "BW")
                    }
                    
                    let username = Data?["username"] as? String ?? ""
                    
                    destinationController.profileHeaderView.name.text = username
                }) { (error) in
                    print(error.localizedDescription)
                }
                
            }
        }
        
    }
    ////////////

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

