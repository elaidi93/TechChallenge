//
//  LiveLocationViewController.swift
//  TechChallenge
//
//  Created by hamza on 8/9/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import MapKit

class LiveLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var _mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let ws = WS()
    let spaceShipManager = SpaceShipMananager()
    
    var coordnate : CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _mapView.delegate = self
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            self.getISSCoordinate()
        }).fire()
        
    }
    
    func getISSCoordinate() {
        
        spaceShipManager.getISSCoordnate { (response) in
            
            if response is String {
                
                let alert = UIAlertController(title: "alert", message: "can't get ISS coordnate", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "retry", style: .default, handler: { (action) in
                    self.getISSCoordinate()
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                if let spaceShipCoordnate = response as? SpaceShip {
                    
                    let coordinate = CLLocationCoordinate2D(latitude: Double(spaceShipCoordnate._latitude)!, longitude: Double(spaceShipCoordnate._longitude)!)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    
                    self._mapView.addAnnotation(annotation)
                    self._mapView.centerCoordinate = coordinate
                    
                }
            }
        }
    }
    
}
