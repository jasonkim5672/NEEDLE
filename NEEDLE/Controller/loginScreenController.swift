//
//  loginScreenControllerViewController.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 12. 8..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class loginScreenController: UIViewController {
    let gradientLayer = CAGradientLayer()
    @IBOutlet var backgroundView:UIView!
    @IBOutlet var backButton:UIButton!
    @IBOutlet var signInButton:UIButton!
    @IBOutlet var signUpButton:UIButton!
    @IBOutlet var facebookSignInButton:UIButton!
   
    @IBAction func backToLoginScreen(segue: UIStoryboardSegue){
        dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientLayer.frame =  CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        
        let color1 = UIColor(red: 136, green: 128, blue: 216).cgColor
        let color2 = UIColor(red: 91, green: 143, blue: 191).cgColor
        gradientLayer.colors = [color1, color2]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.3)
        gradientLayer.endPoint = CGPoint(x: 0.6, y: 0)
        gradientLayer.locations = [0.0, 1.0]
        signUpButton.layer.borderColor = UIColor.white.cgColor // Set border color
        signUpButton.layer.borderWidth = 2
        
        
        
        
        
        
        
        
        
        
        backgroundView.layer.addSublayer(gradientLayer)
        // Do any additional setup after loading the view.
    }
    @IBAction func facebookLogin(sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                let rootRef = Database.database().reference()
                let nameUpdates = ["/users/\(user!.uid)/username": user!.displayName ?? ""]
                
                rootRef.updateChildValues(nameUpdates)
                
                
                
                
                // Present the main view
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "mainView") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
            
        }   
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logInButtonTouched" {
            let destinationController = segue.destination as! FifthViewController
            if let user = Auth.auth().currentUser {
                let uid = user.uid
                destinationController.loginArea.userNumber.text = "회원UID : " + uid
                
                let email = user.email
                if let photoURL = user.photoURL{
                    destinationController.loginArea.userPhoto.image = UIImage(named: String(describing:photoURL))
                }else{
                    destinationController.loginArea.userPhoto.image = UIImage(named: "defaultUser")
                }
                destinationController.loginArea.userName.setTitle(email!+" 님",for: .normal)
                destinationController.loginArea.isUserInteractionEnabled=false
                destinationController.logOutButton.isHidden=false
                //logOutButton.layer.borderColor = UIColor.gray.cgColor // Set border color
                //logOutButton.layer.borderWidth = 1
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
