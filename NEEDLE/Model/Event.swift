//
//  Event.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 12. 9..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import Foundation

class Event{
    var title :String
    var author :String
    var body : String
    var location : String
    var period : String
    var people : String
    var registerTime : String
    var uid : String
    var tag : String
    
    init(title: String, author: String, uid: String, location: String, period: String, registerTime: String, body: String, tag: String, people:String) {
        self.title = title
        self.author = author
        self.location = location
        self.period = period
        self.uid = uid
        self.body = body
        self.registerTime = registerTime
        self.tag = tag
        self.people = people
    }
    
}
