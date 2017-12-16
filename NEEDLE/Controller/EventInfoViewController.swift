//
//  EventPageViewController.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 12. 16..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit

class EventInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var thisEvent : Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var colors = [UIColor]()
        colors.append(UIColor(red: 136, green: 128, blue: 216))
        colors.append(UIColor(red: 91, green: 143, blue: 191))
        
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        nameLabel.text = thisEvent.title
        
        coverImage.image = UIImage(named: "LiveBeats")
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventLocation", for: indexPath) as! InfoTableViewCell
        cell.locationLabel.text = thisEvent.location
        cell.dateLabel.text = thisEvent.period
        cell.peopleLabel.text = thisEvent.people
        cell.summaryLabel.text = thisEvent.body
        
        
        
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
