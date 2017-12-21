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
    var people : Int16
    var registerTime : String
    var uid : String
    var tag : String
    var thumbnailImage : String
    var longitude : Double
    var latitude : Double
    
    
    init(_ title: String,_ author: String,_ body: String,_ location: String,_ period: String,_  people:Int16,_ registerTime: String,_ uid:String ,_ tag: String,_ thumbnailImage : String) {
        self.title = title
        self.author = author
        self.location = location
        self.period = period
        self.uid = uid
        self.body = body
        self.registerTime = registerTime
        self.tag = tag
        self.people = people
        self.longitude = 0.0
        self.latitude = 0.0
        self.thumbnailImage = thumbnailImage
    }
    
}
