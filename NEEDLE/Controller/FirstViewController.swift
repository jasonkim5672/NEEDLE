//
//  FirstViewController.swift
//  niddle
//
//  Created by Jason Kim on 2017. 11. 29..
//  Copyright © 2017년 JasonKim. All rights reserved.
//
/*
 Needle color start 136.128.216
 Needle color end 91.143.181
 */

import UIKit

class FirstViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.gradienBackground(from: UIColor(red:120/255,green:0/255,blue:255/255,alpha:1.0),to: UIColor(red:0/255,green:0/255,blue:255/255,alpha:1.0),direction : 1)
        var colors = [UIColor]()
        colors.append(UIColor(red: 136, green: 128, blue: 216))
        colors.append(UIColor(red: 91, green: 143, blue: 181))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

