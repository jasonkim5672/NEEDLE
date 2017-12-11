//
//  FirstViewController.swift
//  niddle
//
//  Created by Jason Kim on 2017. 11. 29..
//  Copyright © 2017년 JasonKim. All rights reserved.
//
/*
 Needle color start 136.128.216
 Needle color end 91.143.191
 */

import UIKit

class FirstViewController: UIViewController, UIScrollViewDelegate,UIScrollViewAccessibilityDelegate{
    var nearEvents : [Event] = []
    @IBOutlet weak var nearIssuePage: UIPageControl!
    @IBOutlet weak var nearIssueScrollView: UIScrollView!
    @IBOutlet var nearIssueView: EventPostView!
    @IBOutlet var nearIssueView2: EventPostView!
    var nearEventsView : [EventPostView] = []

    @IBOutlet weak var recommendIssueScrollView: UIScrollView!
    @IBOutlet weak var recommendIssueView: EventPostView!
    var recommendEventsView : [EventPostView] = []
    @IBOutlet var mainView: UIView!
    var mainScrollView : UIScrollView! = nil
    var contentWidth :CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nearIssueScrollView.delegate=self
        recommendIssueScrollView.delegate=self

        // Do any additional setup after loading the view, typically from a nib.
        //self.gradienBackground(from: UIColor(red:120/255,green:0/255,blue:255/255,alpha:1.0),to: UIColor(red:0/255,green:0/255,blue:255/255,alpha:1.0),direction : 1)
        mainScrollView = UIScrollView.init(frame: CGRect(x:0,y:0,width: self.mainView.frame.width,height:self.mainView.frame.height ))
        mainScrollView.contentSize = CGSize(width : self.mainView.frame.width,height:self.mainView.frame.height  )
        mainScrollView.addSubview(mainView)
        mainScrollView.isScrollEnabled=true
        var colors = [UIColor]()
        colors.append(UIColor(red: 136, green: 128, blue: 216))
        colors.append(UIColor(red: 91, green: 143, blue: 191))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        var nScreen : Int = 0
        
            //var anotherPage = nearIssueView2!
            //anotherPage.copyEvents(from: nearIssueView)
            
            //var anotherPage2 : EventPostView!
            //anotherPage2.copyEvents(from: recommendIssueView)
            
            nearEventsView.append(nearIssueView)
            nearEventsView.append(nearIssueView2)
            recommendEventsView.append(recommendIssueView)
        
        
        for post in nearEventsView {
            post.thumbnailImage.image = UIImage(named : "TheMan")
            post.profileImage.image = UIImage(named : "Artwork")
            post.titleLabel.text = "첫 이벤트 !!"
            post.authorLabel.text = "김병우"
            post.summaryLabel.text = "선착순 100명 마감!"
            post.dateLabel.text = "2017/12/21"
            //let imageView = UIImageView(image : imageToDisplay)
            //let xCoordinate = nearIssueView.frame.midX + nearIssueView.frame.width * CGFloat(nScreen)
            post.frame = CGRect(x:nScreen*375, y : Int(nearIssueView.frame.midY-(250/2)), width: 375 , height : 250)
            nearIssueScrollView.addSubview(post)
            contentWidth +=  nearIssueView.frame.width
            nScreen+=1
            
        }
        nearIssueScrollView.contentSize = CGSize(width : contentWidth , height : nearIssueView.frame.height)
        nScreen = 0
        for post in recommendEventsView {
            post.thumbnailImage.image = UIImage(named : "LiveBeats")
            post.profileImage.image = UIImage(named : "Bol")
            post.titleLabel.text = "The Events of Week!!"
            post.authorLabel.text = "NEEDLE"
            post.summaryLabel.text = "선착순 100명 마감!"
            post.dateLabel.text = "2017/12/21"
            //let imageView = UIImageView(image : imageToDisplay)
            let xCoordinate = recommendIssueScrollView.frame.midX + recommendIssueScrollView.frame.width * CGFloat(nScreen)
            post.frame = CGRect(x:xCoordinate-(375/2), y : recommendIssueScrollView.frame.midX-(250/2), width: 375 , height : 250)
            post.translatesAutoresizingMaskIntoConstraints = false
            recommendIssueScrollView.addSubview(post)
            contentWidth +=  recommendIssueScrollView.frame.width
            nScreen+=1
            
        }
        recommendIssueScrollView.contentSize = CGSize(width : contentWidth , height : recommendIssueScrollView.frame.height)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        nearIssuePage.currentPage = Int(nearIssueScrollView.contentOffset.x / CGFloat(375))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

