//
//  LocationViewController.swift
//  TechChallenge
//
//  Created by hamza on 8/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var _mapView: MKMapView!
    let locationManager = CLLocationManager()
    let spaceShipManager = SpaceShipMananager()
    
    var coordinate : CLLocationCoordinate2D!
    var cercle: MKCircle!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _mapView.delegate = self
        
        getUserLocation()
        
    }
    
    func getUserLocation() {

        coordinate = _mapView.userLocation.coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = (self.locationManager.location?.coordinate)!
        print(coordinate)

        self._mapView.addAnnotation(annotation)
        self._mapView.centerCoordinate = coordinate
        self._mapView.isZoomEnabled = true
        cercle = MKCircle(center: coordinate, radius: 10000)
        self._mapView.add(cercle)
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            self.getISSCoordinate()
        }
        
    }
    
    func checkCloser(issCoordiante: CLLocationCoordinate2D) {
        
        let currenPoint = self._mapView.renderer(for: cercle) as? MKCircleRenderer
        let issPoint = self._mapView.convert(issCoordiante, toPointTo: self._mapView)
        
        if currenPoint!.path.contains(issPoint) {
            
            let alert = UIAlertController(title: "alert", message: "can't get ISS coordnate", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "retry", style: .default, handler: { (action) in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
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
                    self.checkCloser(issCoordiante: coordinate)
                    
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.fillColor = UIColor.blue
        circleRenderer.strokeColor = UIColor.red
        circleRenderer.lineWidth = 1
        return circleRenderer
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self._mapView.centerCoordinate = (userLocation.location?.coordinate)!
    }
    
    
}
