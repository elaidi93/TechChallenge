//
//  PassengerViewController.swift
//  TechChallenge
//
//  Created by hamza on 8/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class PassengerViewController: UIViewController {

    let spaceShipManager = SpaceShipMananager()
    var passengers = [Passenger]()
    
    @IBOutlet weak var _tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _tableView.delegate = self
        _tableView.dataSource = self
        
        updateTable()
        getPassengers()
        
        _tableView.reloadData()
        
    }

    func getPassengers() {
        
        spaceShipManager.getPassengers { (response) in
            
            if response is String {
                
                let alert = UIAlertController(title: "alert", message: "can't get any passenger", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "retry", style: .default, handler: { (action) in
                    self.getPassengers()
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                self.passengers = response as! [Passenger]
                self._tableView.reloadData()
                
            }
        }
        
    }
    
    func updateTable() {
        
        let nib = UINib(nibName: "PassengerCell", bundle: nil)
        _tableView.register(nib, forCellReuseIdentifier: "passenger")
        
    }

}

extension PassengerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passengers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = _tableView.dequeueReusableCell(withIdentifier: "passenger", for: indexPath) as! PassengerTableViewCell
        cell._name.text = self.passengers[indexPath.row]._name
        return cell
    }
    
}
