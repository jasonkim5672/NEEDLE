//
//  FifthViewController.swift
//  niddle
//
//  Created by Jason Kim on 2017. 11. 29..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit

class FifthViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var loginArea: loginAreaView!
    @IBOutlet weak var backgroundLayer: UIView!
    
    let menuList = ["구독목록", "정보수정", "설정", "고객센터"]
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
        
        loginArea.userPhoto.image = UIImage(named: "defaultUser")
        loginArea.userName.text = "로그인이 필요합니다."
        loginArea.userNumber.text = "비회원번호 : 33709522"
        backgroundLayer.layer.addSublayer(gradientLayer)
        
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
