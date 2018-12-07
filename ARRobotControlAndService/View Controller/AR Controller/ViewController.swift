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
    
    var tableView = UITableView(frame: CGRect(x:0, y: 1, width:300, height: 400))
    let erzeugeSCNNode = ErzeugeSCNNode()
    var anzeige:Bool = false
    var document = [Roboter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func loadData(){
        FirebaseHelper.getDB().collection("roboter").getDocuments(){
            querySnapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            }else {
                self.document = querySnapshot!.documents.compactMap({Roboter(dictionary: $0.data())})
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func checkForUpdates(){
        FirebaseHelper.getDB().collection("roboter")
            .addSnapshotListener({
                querySnapshot, error in
                guard let snapshot = querySnapshot else {return}
                
                snapshot.documentChanges.forEach{
                    diff in
                    
                    if diff.type == .modified {
                        var anzahl = 0
                        for rob in self.document
                        {
                            if(rob.name == Roboter(dictionary: diff.document.data())!.name){
                                self.document[anzahl] = Roboter(dictionary: diff.document.data())!
                                anzahl = anzahl + 1
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        let change = Roboter(dictionary: diff.document.data())!
                        print(self.document)
                        print(change)
                        
                    }
                    
                    if diff.type == .added {
                        self.document.append(Roboter(dictionary: diff.document.data())!)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            })
    }
  
}
