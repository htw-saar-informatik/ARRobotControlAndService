//
//  ViewController + UiViewController.swift
//  ARRobotControlAndService
//
//  Created by Marco Becker on 07.12.18.
//  Copyright © 2018 Marco Becker. All rights reserved.
//

import Foundation
import UIKit


extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return werte.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let roboter = werte[indexPath.row]
        cell.textLabel?.text = "\(roboter.value.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "").replacingOccurrences(of: "\"", with: ""))"
        
        
        
        return cell
        
    }
    
    
}
