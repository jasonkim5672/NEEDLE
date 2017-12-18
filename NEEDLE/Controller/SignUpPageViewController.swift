//
//  SignUpPageViewController.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 12. 17..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit
import Firebase

class SignUpPageViewController: UIViewController {
    var rootRef : DatabaseReference!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        self.view.endEditing(true)
        
    }
    
    @IBAction func signUpButtonTapped(segue: UIStoryboardSegue){
        if(self.emailTextField.text!.isEmpty || self.passwordTextField.text!.isEmpty||self.nameTextField.text!.isEmpty){
            let alert = UIAlertController(title: "Oops", message: "모든항목을 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil ))
            self.present(alert, animated: true, completion: nil)
            
        }else if self.passwordTextField.text!.count < 6{
            let alert = UIAlertController(title: "Oops", message: "비밀번호는 6자리 이상 돼야합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil ))
            self.present(alert, animated: true, completion: nil)
        }else{
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!){ (user, error) in
                if user !=  nil{
                    let follower : [String] = [""]
                    let data = ["username": self.nameTextField.text!,"coverImage":"","follower":follower] as [String : Any]
                    self.rootRef = Database.database().reference()

                    self.rootRef.child("users/\(String(describing: user!.uid))").setValue(data)
                    
                    print("register success")
                    let alert = UIAlertController(title: "Welcome", message: "회원가입이 완료되었습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler:  {(alert: UIAlertAction!) in
                        self.dismiss(animated: true, completion: nil)} ))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else{
                    
                    print("register failed")
                    let alert = UIAlertController(title: "Oops", message: "일시적인 오류가 발생하였습니다. 다시 시도해주세요.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil ))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }
         
        }
    }
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
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
        self.rootRef = Database.database().reference()
        
        
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
