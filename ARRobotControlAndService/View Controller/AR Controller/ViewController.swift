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
    let erzeugeSCNNode = ErzeugeSCNNode()
    var anzeige:Bool = false
    var document = [Roboter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        loadData()
        checkForUpdates()
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
