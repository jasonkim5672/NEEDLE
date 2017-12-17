//
//  MessageTabBarControllerViewController.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 12. 15..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit
//UIViewController,
class MessageTabBarController: UITabBarController {
    let customTabBarView = UIView()
    let tabBtn01 = UIButton()
    let tabBtn02 = UIButton()
    let tabBtn03 = UIButton()
    let btn1UnderLine = UIView()
    let btn2UnderLine = UIView()
    let btn3UnderLine = UIView()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true
  
        customTabBarView.frame = CGRect(x:0, y:60, width:self.view.frame.size.width, height:40)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  CGRect(x: 0.0, y: -(self.navigationController?.view.frame.height)!, width: self.view.bounds.size.width, height: (self.navigationController?.view.frame.height)!+40)

        let color1 = UIColor(red: 136, green: 128, blue: 216).cgColor
        let color2 = UIColor(red: 91, green: 143, blue: 191).cgColor
        gradientLayer.colors = [color1, color2]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.3)
        gradientLayer.endPoint = CGPoint(x: 0.6, y: 0)
        gradientLayer.locations = [0.0, 1.0]
        customTabBarView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        customTabBarView.layer.addSublayer(gradientLayer)
        let widthOfOneBtn = self.tabBar.frame.size.width/3
        
        let heightOfOneBtn = self.customTabBarView.frame.height
        
        
        
        tabBtn01.frame = CGRect(x:0, y:0, width: widthOfOneBtn,height: heightOfOneBtn)
        btn1UnderLine.frame = CGRect(x:10,y:35,width: widthOfOneBtn-10,height:5)
        tabBtn02.frame = CGRect(x: widthOfOneBtn, y: 0, width:widthOfOneBtn, height: heightOfOneBtn)
        btn2UnderLine.frame = CGRect(x:widthOfOneBtn+5,y:35,width:widthOfOneBtn-10,height:5)
        tabBtn03.frame = CGRect(x: widthOfOneBtn*2, y: 0, width:widthOfOneBtn, height: heightOfOneBtn)
        btn3UnderLine.frame = CGRect(x:widthOfOneBtn*2+5,y:35,width:widthOfOneBtn-10,height:5)
        
        
        tabBtn01.setTitle("모든 메세지", for: .normal)
        tabBtn01.titleLabel!.font = UIFont.boldSystemFont(ofSize: 15)
        tabBtn02.setTitle("공지사항", for: .normal)
        tabBtn02.titleLabel!.font = UIFont.boldSystemFont(ofSize: 15)
        tabBtn03.setTitle("쪽지함", for: .normal)
        tabBtn03.titleLabel!.font = UIFont.boldSystemFont(ofSize: 15)
        btn1UnderLine.backgroundColor = UIColor(red: 1 , green : 1, blue:1,alpha :1)
        btn2UnderLine.backgroundColor = UIColor(red: 1 , green : 1, blue:1,alpha :1)
        btn3UnderLine.backgroundColor = UIColor(red: 1 , green : 1, blue:1,alpha :1)
        btn2UnderLine.isHidden = true
        btn3UnderLine.isHidden = true
        customTabBarView.addSubview(btn1UnderLine)
        customTabBarView.addSubview(btn2UnderLine)
        customTabBarView.addSubview(btn3UnderLine)
        tabBtn01.tag = 0
        tabBtn02.tag = 1
        tabBtn03.tag = 2
        
        
        setAttributeTabBarButton(tabBtn01)
        setAttributeTabBarButton(tabBtn02)
        setAttributeTabBarButton(tabBtn03)
        
        self.view.addSubview(customTabBarView)
        
        // Do any additional setup after loading the view.
    }
    
    func setAttributeTabBarButton(_ btn : UIButton)
    {
        btn.addTarget(self, action: #selector(onBtnClick(sender:)), for: UIControlEvents.touchUpInside)
        //btn.addTarget(self, action: #selector(pushToNext(sender:)), for: .touchUpInside)
        btn.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        btn.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .selected)
        self.customTabBarView.addSubview(btn)
        
    }
    
    func pushToNext(sender : UIButton) {
       
    }
    
    
    @objc func onBtnClick(sender : UIButton)
    {
        selectMessageItem = sender.tag
        
        
        self.tabBtn01.isSelected = false
        self.tabBtn02.isSelected = false
        self.tabBtn03.isSelected = false
        self.btn1UnderLine.isHidden = true
        self.btn2UnderLine.isHidden = true
        self.btn3UnderLine.isHidden = true
        sender.isSelected = true
      
        self.selectedIndex = sender.tag
        switch sender.tag{
        case 0:
            self.btn1UnderLine.isHidden = false
        case 1:
            self.btn2UnderLine.isHidden = false
        case 2:
            self.btn3UnderLine.isHidden = false
        default:
            print("sth wrong")
            
        }
        
        
        
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
