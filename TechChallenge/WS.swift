//
//  WS.swift
//  TechChallenge
//
//  Created by hamza on 8/9/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

class WS {
    
    let issLivePosition = "http://api.open-notify.org/iss-now.json"
    let passengers      = "http://api.open-notify.org/astros.json"
    
    
    func getISSPostion(callback:@escaping (Any)->()){
        requestGet(url: issLivePosition, callback: callback)
    }
    
    func getPassengers(callback:@escaping (Any)->()){
        requestGet(url: passengers, callback: callback)
    }

    // POST
    func requestPost(url:String, params:String, callback:@escaping (Any)->()) {
        
        let nsURL = NSURL(string: url)
        let cashPolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let request = NSMutableURLRequest(url: nsURL! as URL,cachePolicy: cashPolicy,timeoutInterval: 60.0)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = params.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            guard data != nil else {
                print("no data found: \(String(describing: error))")
                callback("nook" as String)
                return
            }
            do {
                let parsed = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                callback(parsed as AnyObject)
            }catch {
                print("json error: \(error)")
                callback("nook")
            }
        }
        task.resume()
    }
    
    // GET
    func requestGet(url:String, callback:@escaping (Any)->()){
        let cashPolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let request = NSMutableURLRequest(url: URL(string: url)!, cachePolicy: cashPolicy, timeoutInterval: 60.0)
        
        request.httpMethod = "GET"
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        do
        {
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                guard error == nil else {
                    callback("no connection")
                    return
                }
                guard let data = data else {
                    print("Data is empty")
                    callback("LC")
                    return
                }
                do{
                    let parsed = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    callback(parsed as AnyObject)
                }catch {
                    print("json error: \(error)")
                    callback("nook")
                }
            })
            
            task.resume()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
}
