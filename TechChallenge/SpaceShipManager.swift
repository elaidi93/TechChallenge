//
//  SpaceShipManager.swift
//  TechChallenge
//
//  Created by hamza on 8/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class SpaceShipMananager {
    
    let ws = WS()
    var spaceShip: SpaceShip?
    var passengers: [Passenger] = []
    
    func getISSCoordnate(callback: @escaping (Any)->()) {
        
        ws.getISSPostion() { (response) in
            
            if response is String {
                
                print("no data find")
                
            } else {
            
                let data = response as! NSDictionary
                let crdnt = data["iss_position"] as! NSDictionary
                
                if data["message"] as! String == "success" {
                    
                    self.spaceShip = SpaceShip(name: "ISS",
                                               longitude: crdnt["longitude"] as! String,
                                               latitude: crdnt["latitude"] as! String,
                                               time: data["timestamp"] as! TimeInterval)
                    callback(self.spaceShip!)
                } else {
                    callback("Empty")
                    
                }
            }
        }
    }
    
    func getPassengers(callback: @escaping (Any)->()) {
        
        ws.getPassengers() { (response) in
            
            if response is String {
                
                print("no data find")
                
            } else {
            
                let data = response as! NSDictionary
                
                if (data["message"] as! String) == "success" {
                    
                    let people = data["people"] as! [NSDictionary]
                    
                    for person in people {
                        
                        self.passengers.append(Passenger(name: person["name"] as! String, craft: person["craft"] as! String))
                        
                    }
                    
                    callback(self.passengers)
                    
                } else {
                    
                    callback("Empty")
                    
                }
            }
        }
    }
    
}
