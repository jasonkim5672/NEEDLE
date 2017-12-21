//
//  NDConstants.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 12. 20..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import Foundation
import SwiftyJSON
import Firebase

var NDEventHandler:DatabaseHandle!
var NDFollowerHandler:DatabaseHandle!
var NDFollowEventHandler:DatabaseHandle!

func callEvents(){
    let postRef = Database.database().reference().child("posts")
    
    NDEventHandler = postRef.observe(DataEventType.value, with: { (snapshot) in
        if let Data = snapshot.value as? NSDictionary{
            for row in Data as! [String:NSDictionary] {
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    var event = EventMO(context: appDelegate.persistentContainer.viewContext)
                    let todaysDate:Date = Date()
                    let dateFormatter:DateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
                    let today :String = dateFormatter.string(from:todaysDate)
                    event.title = row.value["title"] as? String ?? " "
                    event.author = row.value["author"] as? String ?? " "
                    event.uid = row.value["uid"] as? String ?? " "
                    event.location = row.value["location"] as? String ?? " "
                    event.period = row.value["period"] as? String ?? today
                    event.registerTime = row.value["registerTime"] as? String ?? " "
                    event.body = row.value["body"] as? String ?? " "
                    event.tag = row.value["tag"] as? String ?? " "
                    event.people = row.value["people"] as? Int16 ?? 100
                    event.thumbnailImage = row.value["thumbnailImage"] as? String ?? " "
                    NDEventSet.insert(event)
                    print("#############")
                    print(row)
                    print("#############")
                    NDEvents = Array(NDEventSet)
                    
                }
            }        }
    }){ (error) in
        print(error.localizedDescription)
    }
    
}
func callFollowList(){
    if let user = Auth.auth().currentUser {
        
        let FollowListRef = Database.database().reference().child("users").child(user.uid).child("follower")
        
        NDFollowerHandler = FollowListRef.observe(DataEventType.value, with: { (snapshot) in
            if let post = snapshot.value as? [String]{
                for i in post{
                    NDFollowList.insert(i)
                    print("@@@@@@@@@@@@@@@@")
                    print(i)
                    print("@@@@@@@@@@@@@@@@")
                    
                }
                
                
            }
        })
        
    }
    
}


func callFollowEvent(){
    let rootRef = Database.database().reference()
    
    for user in NDFollowList{
        rootRef.child("user-posts").child(user).observeSingleEvent(of: .value, with: { (userData) in
            // Get user value
            if let Data = userData.value as? NSDictionary{
                for row in Data as! [String:NSDictionary] {
                    if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                        var event = FollowEventMO(context: appDelegate.persistentContainer.viewContext)
                        let todaysDate:Date = Date()
                        let dateFormatter:DateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
                        let today :String = dateFormatter.string(from:todaysDate)
                        event.title = row.value["title"] as? String ?? " "
                        event.author = row.value["author"] as? String ?? " "
                        event.uid = row.value["uid"] as? String ?? " "
                        event.location = row.value["location"] as? String ?? " "
                        event.period = row.value["period"] as? String ?? today
                        event.registerTime = row.value["registerTime"] as? String ?? " "
                        event.body = row.value["body"] as? String ?? " "
                        event.tag = row.value["tag"] as? String ?? " "
                        event.people = row.value["people"] as? Int16 ?? 100
                        event.thumbnailImage = row.value["thumbnailImage"] as? String ?? " "
                        NDFollowEvents.append(event)
                        print(row)
                        
                    }
                }
            }
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

func callFollowEventFromEvent(){
    
    for i in NDEvents{
        if NDFollowList.contains(i.uid!){
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                
                var event = FollowEventMO(context: appDelegate.persistentContainer.viewContext)
                
                event.title = i.title!
                event.author = i.author!
                event.uid = i.uid!
                event.location = i.location!
                event.period = i.period!
                event.registerTime = i.registerTime!
                event.body = i.body!
                event.tag = i.tag!
                event.people = i.people
                event.thumbnailImage = i.thumbnailImage
                NDFollowEventSet.insert(event)
                NDFollowEvents = Array(NDFollowEventSet)
            }
            
        }
    }
}


func updatePins(){
    NDPins = []
    let helper = DispatchQueue.global()
    for i in NDEvents{
        helper.sync {
        getRoadAddress(i.location!)
        }
        
        while NDtmpAddress == "" { }
        
        getGeocodeFromRoadAddress(NDtmpAddress)
        NDtmpAddress = ""
    }
}

func getRoadAddress(_ address: String){
    
    let urlStringWithKoreanFirst = "https://openapi.naver.com/v1/search/local.json?query=\(address)&display=1&start=1&sort=random"
    let urlStringFirst = urlStringWithKoreanFirst.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let requestFirst : NSMutableURLRequest = NSMutableURLRequest()
    requestFirst.url = URL(string: urlStringFirst)
    requestFirst.httpMethod = "GET"
    
    
    requestFirst.addValue("eBknY0lClg3MZUJW1TOB", forHTTPHeaderField: "X-Naver-Client-Id")
    requestFirst.addValue("QCvw3f_VdV", forHTTPHeaderField: "X-Naver-Client-Secret")
    
    let sessionFirst = URLSession.shared
    let taskFirst = sessionFirst.dataTask(with: requestFirst as URLRequest, completionHandler: {
        data, response, error -> Void in
        print(response!)
        do {
            if let data = data{
                let json:JSON = try JSON(data: data)
                print(json)
                NDtmpAddress.append( json["items"][0]["address"].string ?? "")
                //NDtmpRoadAddress.append(json["items"][0]["roadAddress"].string ?? "")
                
                
            }else{print("JSON REQUEST ERROR")
                //NDtmpAddress = "-1"
                
            }
            
        } catch {
            print("error")
            //NDtmpAddress = "-1"
        }
    })
    
    taskFirst.resume()
}

/*
 func getGeocodeFromRoadAddress(){
 for i in NDtmpAddress {
 let urlStringWithKorean = "https://openapi.naver.com/v1/map/geocode?query=\(i)&display=1&start=1&sort=random"
 let urlString = urlStringWithKorean.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
 let request : NSMutableURLRequest = NSMutableURLRequest()
 request.url = URL(string: urlString)
 request.httpMethod = "GET"
 
 
 request.addValue("eBknY0lClg3MZUJW1TOB", forHTTPHeaderField: "X-Naver-Client-Id")
 request.addValue("QCvw3f_VdV", forHTTPHeaderField: "X-Naver-Client-Secret")
 
 let session = URLSession.shared
 let task = session.dataTask(with: request as URLRequest, completionHandler: {
 data, response, error -> Void in
 // print(response!)
 do {
 //let json:JSON  = try JSONSerialization.jsonObject(with: data!,options:JSONSerialization.ReadingOptions.mutableContainers)
 if let data = data{
 let json:JSON = try JSON(data: data)
 print(json)
 let longitude = json["result"]["items"][0]["point"]["x"].double ?? 0.0
 let latitude = json["result"]["items"][0]["point"]["y"].double ?? 0.0
 let pin : NGeoPoint = NGeoPoint(longitude: longitude, latitude: latitude)
 NDPins.append(pin)
 //self.addMarker(pin)
 //let pin2 : NGeoPoint = NGeoPoint(longitude:126.712460, latitude: self.latitude)
 // self.addMarker(pin2)
 
 }else{print("JSON REQUEST ERROR")
 //NDtmpAddress = "-1"
 }
 } catch {
 print("error")
 //NDtmpAddress = "-1"
 }
 })
 
 task.resume()
 }
 }
 */

func getGeocodeFromRoadAddress(_ roadAddress : String){
    let urlStringWithKorean = "https://openapi.naver.com/v1/map/geocode?query=\(roadAddress)&display=1&start=1&sort=random"
    let urlString = urlStringWithKorean.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let request : NSMutableURLRequest = NSMutableURLRequest()
    request.url = URL(string: urlString)
    request.httpMethod = "GET"
    
    
    request.addValue("eBknY0lClg3MZUJW1TOB", forHTTPHeaderField: "X-Naver-Client-Id")
    request.addValue("QCvw3f_VdV", forHTTPHeaderField: "X-Naver-Client-Secret")
    
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest, completionHandler: {
        data, response, error -> Void in
        // print(response!)
        do {
            //let json:JSON  = try JSONSerialization.jsonObject(with: data!,options:JSONSerialization.ReadingOptions.mutableContainers)
            if let data = data{
                let json:JSON = try JSON(data: data)
                print(json)
                let longitude = json["result"]["items"][0]["point"]["x"].double ?? 0.0
                let latitude = json["result"]["items"][0]["point"]["y"].double ?? 0.0
                let pin : NGeoPoint = NGeoPoint(longitude: longitude, latitude: latitude)
                NDPin = pin
                NDPins.append(pin)
                //self.addMarker(pin)
                //let pin2 : NGeoPoint = NGeoPoint(longitude:126.712460, latitude: self.latitude)
                // self.addMarker(pin2)
                
            }else{print("JSON REQUEST ERROR")
                //NDtmpAddress = "-1"
            }
        } catch {
            print("error")
            //NDtmpAddress = "-1"
        }
    })
    
    task.resume()
    
}

let backgroundTask = DispatchQueue.global()
let ND_GCD = DispatchGroup()
let q1 = DispatchQueue(label: "translate address")
let q2 = DispatchQueue(label: "call Events")
let q3 = DispatchQueue(label: "call Events")
var NDtmpRoadAddress = ""
var NDtmpAddress = ""
var NDEvents : [EventMO] = []
var NDEventSet : Set<EventMO> = []
var NDFollowEvents : [FollowEventMO] = []
var NDFollowEventSet : Set<FollowEventMO> = []
var NDPins : [NGeoPoint] = []
var NDPin : NGeoPoint = NGeoPoint(longitude: 0, latitude: 0)
var NDFollowList : Set<String> = []
let storage = Storage.storage()

