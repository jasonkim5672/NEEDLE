//
//  UpTabbarController.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 12. 9..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit

class UpTabbarController: UITabBarController {
    let customTabBarView = UIView()
    let tabBtn01 = UIButton()
    let tabBtn02 = UIButton()
    let gradientLayer = CAGradientLayer()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.isHidden = true
        gradientLayer.frame =  CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width, height: 30)
        let color1 = UIColor(red: 136, green: 128, blue: 216).cgColor
        let color2 = UIColor(red: 91, green: 143, blue: 191).cgColor
        gradientLayer.colors = [color1, color2]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.3)
        gradientLayer.endPoint = CGPoint(x: 0.6, y: 0)
        gradientLayer.locations = [0.0, 1.0]
        
        customTabBarView.frame = gradientLayer.frame
        customTabBarView.layer.addSublayer(gradientLayer)
        
        let widthOfOneBtn = self.tabBar.frame.size.width/2
        let heightOfOneBtn = self.customTabBarView.frame.height
       
        tabBtn01.frame = CGRect(x:0, y:0, width: widthOfOneBtn, height: heightOfOneBtn)
        tabBtn02.frame = CGRect(x: widthOfOneBtn, y: 0, width :widthOfOneBtn, height : heightOfOneBtn)
        
        tabBtn01.setTitle("첫번째 버튼", for: .normal)
        tabBtn02.setTitle("두번째 버튼", for: .normal)
        
        tabBtn01.tag = 0
        tabBtn02.tag = 1
        
        setAttributeTabBarButton(btn: tabBtn01)
        setAttributeTabBarButton(btn: tabBtn02)
        
        
        
        self.view.addSubview(customTabBarView)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setAttributeTabBarButton(btn : UIButton)
    {
        btn.addTarget(self, action: #selector(onBtnClick), for: UIControlEvents.touchUpInside)
        btn.setTitleColor(UIColor(red: 0.5, green: 0.5, blue: 0, alpha: 1), for: .normal)
        btn.setTitleColor(UIColor(red: 1, green: 1, blue: 0, alpha: 1), for: .selected)
        self.customTabBarView.addSubview(btn)
    }
    
    @objc
    func onBtnClick(sender : UIButton)
    {
        self.tabBtn01.isSelected = false
        self.tabBtn02.isSelected = false
        
        sender.isSelected = true
        
        self.selectedIndex = sender.tag
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
