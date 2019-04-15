//
//  ViewController.swift
//  ARRobotControlAndService
//
//  Created by Marco Becker on 06.12.18.
//  Copyright © 2018 Marco Becker. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController{

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var configButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var restButton: UIButton!
    @IBOutlet var profilButton: UIButton!
    let erzeugeSCNNode = ErzeugeSCNNode()
    var anzeige:Bool = false
    var werte: [(key: String, value: String)] = []
    var userAnzeige: [(key: String, value: String)] = []
    var saveUserID:String = ""
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        uiAnpassung()
        
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    @IBAction func restButtonTapped(_ sender: Any) {
        anzeige = false
        werte.removeAll()
        sceneView.scene.rootNode.enumerateChildNodes{(planeNode, _) in
            planeNode.removeFromParentNode()
        }
    }
    // MARK: - ARSCNViewDelegate
    
    func loadData(imageName: String){
        FirebaseHelper.getDB().collection("roboter").document(imageName).collection("content").getDocuments(){
            querySnapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                for document in querySnapshot!.documents{
                    print("\(document.documentID) => \(document.data())")
                    do {
                        let data = try JSONSerialization.data(withJSONObject: document.data(), options: JSONSerialization.WritingOptions.prettyPrinted)
                        if let string = String(data: data, encoding: String.Encoding.utf8) {
                            self.werte.append((key: document.documentID, value: string))
                        }
                    } catch {
                        print(error)
                    }
                    
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    
    func checkForUpdates(imageName: String){
        self.werte.removeAll()
        FirebaseHelper.getDB().collection("roboter").document(imageName).collection("content")
            .addSnapshotListener({
                querySnapshot, error in
                guard let snapshot = querySnapshot else {return}
                self.werte.removeAll()
                snapshot.documentChanges.forEach{
                    diff in
                    if diff.type == .modified {
                        do {
                            let data = try JSONSerialization.data(withJSONObject: diff.document.data(), options: JSONSerialization.WritingOptions.prettyPrinted)
                            if let string = String(data: data, encoding: String.Encoding.utf8) {
                                var i: Int = 0
                                for (key, value) in self.werte {
                                    if (key == diff.document.documentID) {
                                        self.werte[i] = (key: diff.document.documentID, value: string)
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
                        for(element, wert) in self.userAnzeige {
                            if(element == diff.document.documentID && wert.contains("true")){
                                do {
                                    let data = try JSONSerialization.data(withJSONObject: diff.document.data(), options: JSONSerialization.WritingOptions.prettyPrinted)
                                    if let string = String(data: data, encoding: String.Encoding.utf8) {
                                        self.werte.append((key: diff.document.documentID, value: string))
                                    }
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        })
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
                            self.checkForUserConfig()
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
    
    func uiAnpassung(){
        ladeProfil()
        if saveUserID != ""
        {
            loginButton.isHidden = true;
            profilButton.isHidden = false;
            configButton.isHidden = false;
        }
        else
        {
            loginButton.isHidden = false
            profilButton.isHidden = true
            configButton.isHidden = true
        }
    }
    
    func checkForUserConfig(){
        userAnzeige.removeAll()
        FirebaseHelper.getDB().collection("user").document(saveUserID).collection("Config")
            .addSnapshotListener({
                querySnapshot, error in
                guard let snapshot = querySnapshot else {return}
                
                snapshot.documentChanges.forEach{
                    diff in
                    
                    if diff.type == .modified {
                        do {
                            let data = try JSONSerialization.data(withJSONObject: diff.document.data(), options: JSONSerialization.WritingOptions.prettyPrinted)
                            if let string = String(data: data, encoding: String.Encoding.utf8) {
                                var i: Int = 0
                                for (key, value) in self.werte {
                                    if key == diff.document.documentID {
                                        self.userAnzeige[i] = (key: diff.document.documentID, value: string.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "").replacingOccurrences(of: "\(diff.document.documentID)", with: "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: ":", with: "").replacingOccurrences(of: " ", with: ""))
                                    } else {
                                        i += 1
                                    }
                                }
                            }
                        } catch {
                            print(error)
                        }
                        if(self.name.isEmpty == false) {
                            print("TEST")
                            print(self.name)
                            self.werte.removeAll()
                            self.checkForUpdates(imageName: self.name)
                        }
                    }
                    if diff.type == .added {
                        do {
                            let data = try JSONSerialization.data(withJSONObject: diff.document.data(), options: JSONSerialization.WritingOptions.prettyPrinted)
                            if let string = String(data: data, encoding: String.Encoding.utf8) {
                                self.userAnzeige.append((key: diff.document.documentID, value: string.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "").replacingOccurrences(of: "\(diff.document.documentID)", with: "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: ":", with: "").replacingOccurrences(of: " ", with: "")))
                            }
                            
                        } catch {
                            print(error)
                        }
                        if(self.name.isEmpty == false) {
                            print("TEST")
                            print(self.name)
                            self.werte.removeAll()
                            self.checkForUpdates(imageName: self.name)
                        }
                    
                    }
                }
                
            })
        
        
    }
  
}
