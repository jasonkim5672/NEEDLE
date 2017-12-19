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

func callEvents(){
    let rootRef = Database.database().reference()
    rootRef.child("posts").observeSingleEvent(of: .value, with: { (userData) in
        // Get user value
        if let Data = userData.value as? NSDictionary{
            for row in Data as! [String:NSDictionary] {
                NDEvents.append(Event.init(title: row.value["title"] as? String ?? " ",author : row.value["author"] as? String ?? " ", uid :row.value["uid"] as? String ?? " " , location: row.value["location"] as? String ?? " " , period : row.value["period"] as? String ?? " ",registerTime: row.value["registerTime"] as? String ?? " ",body : row.value["body"] as? String ?? " ",tag : row.value["tag"] as? String ?? " ",people : row.value["people"] as? String ?? " "))
                print(row)
            }
        }
        
    }) { (error) in
        print(error.localizedDescription)
    }
    
    
}
func updatePins(){
    NDPins = []
    for i in NDEvents{
        getRoadAddress(i.location)
        while NDtmpAddress == "" { }
        getGeocodeFromRoadAddress(NDtmpAddress)
        NDtmpAddress = ""
    }
    
    
    
        /*
        q2.async {
            while NDtmpRoadAddress != "" || NDtmpAddress != "" { }

            getRoadAddress(i.location)
       
            while NDtmpRoadAddress == "" && NDtmpAddress == "" { }
            if(NDtmpRoadAddress != ""){getGeocodeFromRoadAddress(NDtmpRoadAddress)}
            else if(NDtmpAddress != ""){getGeocodeFromRoadAddress(NDtmpAddress)}
            
            NDtmpAddress = ""
            NDtmpRoadAddress = ""
        }
        //while NDtmpRoadAddress == "" || NDtmpAddress == "" { }
        
        */
        
        
    
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
var NDEvents : [Event] = []
var NDPins : [NGeoPoint] = []
