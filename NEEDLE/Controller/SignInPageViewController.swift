//
//  LoginPageViewController.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 12. 17..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit
import Firebase

class SignInPageViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        self.view.endEditing(true)
        
    }
    @IBAction func signInButtonTapped(segue: UIStoryboardSegue){
          self.view.endEditing(true)
        if(self.emailTextField.text!.isEmpty || self.passwordTextField.text!.isEmpty){
            let alert = UIAlertController(title: "Oops", message: "모든항목을 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil ))
            self.present(alert, animated: true, completion: nil)
            
        }else if self.passwordTextField.text!.count < 6{
            let alert = UIAlertController(title: "Oops", message: "비밀번호는 6자리 이상 돼야합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil ))
            self.present(alert, animated: true, completion: nil)
        }else{
            let rootRef = Database.database().reference()
            
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                if user != nil{
                    print("login success")
                    if let user = Auth.auth().currentUser {
                        rootRef.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (userData) in
                            // Get user value
                            let alert = UIAlertController(title: "Welcome To NEEDLE", message: "로그인 되었습니다.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil ))
                            self.present(alert, animated: true, completion: nil)
                            self.dismiss(animated: true){
                                self.dismiss(animated: true,completion: nil)
                            }
                            // ...
                        }) { (error) in
                            print(error.localizedDescription)
                        }
                        
                    }
                }
                else{
                    print("login fail")
                    let alert = UIAlertController(title: "오류!", message: "잠시 후에 다시 시도해주세요.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil ))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }
    }

    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientLayer.frame =  CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        
        let color1 = UIColor(red: 136, green: 128, blue: 216).cgColor
        let color2 = UIColor(red: 91, green: 143, blue: 191).cgColor
        gradientLayer.colors = [color1, color2]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.3)
        gradientLayer.endPoint = CGPoint(x: 0.6, y: 0)
        gradientLayer.locations = [0.0, 1.0]
        self.backgroundView.layer.addSublayer(gradientLayer)
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        
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
