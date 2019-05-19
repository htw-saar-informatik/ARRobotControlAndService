//
//  ConfigurationViewController.swift
//  ARRobotControlAndService
//
//  Created by Marco Becker on 07.12.18.
//  Copyright © 2018 Marco Becker. All rights reserved.
//

import UIKit

class ConfigurationViewController: UITableViewController {

    var saveUserID:String = ""
    var werte: [(key: String, value: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        ladeProfil()
        //checkForUpdates()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return werte.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let anzeige = werte[indexPath.row]
        cell.textLabel?.text = "\(anzeige.key)"
        let switchView = UISwitch(frame: .zero)
        if(anzeige.value == "true"){
            switchView.setOn(true, animated: true)
        }else{
            switchView.setOn(false, animated: true)
        }
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView
        return cell
    }
    
    @objc func switchChanged(_ sender : UISwitch!){
        print("table row switch Changed \(sender.tag)")
        if(sender.isOn){
            print("The switch is \(sender.isOn ? "ON" : "OFF")")
            updateDB(eintrag: werte[sender.tag].key, wert: true)
        }
        else{
            print("The switch is \(sender.isOn ? "ON" : "OFF")")
            updateDB(eintrag: werte[sender.tag].key, wert: false)
        }
        
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    func updateDB(eintrag: String, wert: Bool){
        FirebaseHelper.getDB().collection("user").document(saveUserID).collection("Config").document(eintrag).updateData(["\(eintrag)": wert]) {
            err in
            if let err = err {
                print("Error")
            } else {
                print("Update successfull")
            }
        }
    }

    
    func ladeProfil(){
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            let loginType = userInformation["type"] as! String
            if loginType == "mail"{
                saveUserID = userInformation["userid"] as! String
                let savedEmail = userInformation["email"] as! String
                let savedPassword = userInformation["password"] as! String
                AuthenticationController.loginUser(withEmail: savedEmail, password: savedPassword) { [weak weakSelf = self](userId) in
                    DispatchQueue.main.async {
                        if let userId = userId, userId == self.saveUserID {
                            self.checkForUpdates()
                        } else {
                        }
                    }
                }
            }
        }
        else{
            saveUserID = ""
        }
    }
    
    func checkForUpdates(){
        FirebaseHelper.getDB().collection("user").document(saveUserID).collection("Config")
            .addSnapshotListener({
                querySnapshot, error in
                guard let snapshot = querySnapshot else {return}
                
                snapshot.documentChanges.forEach{
                    diff in
                    
                    if diff.type == .modified {
                        var anzahl = 0
                        do {
                            let data = try JSONSerialization.data(withJSONObject: diff.document.data(), options: JSONSerialization.WritingOptions.prettyPrinted)
                            if let string = String(data: data, encoding: String.Encoding.utf8) {
                                var i: Int = 0
                                for (key, value) in self.werte {
                                    if key == diff.document.documentID {
                                        self.werte[i] = (key: diff.document.documentID, value: string.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "").replacingOccurrences(of: "\(diff.document.documentID)", with: "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: ":", with: "").replacingOccurrences(of: " ", with: ""))
                                    } else {
                                        i += 1
                                    }
                                }
                            }
                        } catch {
                            print(error)
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    if diff.type == .added {
                        do {
                            let data = try JSONSerialization.data(withJSONObject: diff.document.data(), options: JSONSerialization.WritingOptions.prettyPrinted)
                            if let string = String(data: data, encoding: String.Encoding.utf8) {
                                self.werte.append((key: diff.document.documentID, value: string.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "").replacingOccurrences(of: "\(diff.document.documentID)", with: "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: ":", with: "").replacingOccurrences(of: " ", with: "")))
                            }
                        } catch {
                            print(error)
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    }
                }
            })
    }
    

}
