//
//  ViewController + ARSCNViewDelegate.swift
//  ARRobotControlAndService
//
//  Created by Marco Becker on 07.12.18.
//  Copyright © 2018 Marco Becker. All rights reserved.
//

import Foundation
import ARKit
extension ViewController: ARSCNViewDelegate, ARSessionDelegate {
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor){
        // guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        
        if !anzeige {
            anzeige = true
            guard let imageAnchor = anchor as? ARImageAnchor else {return}
            guard let currentFrame = sceneView.session.currentFrame else {return}
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -3
            
            
            if let imageName = imageAnchor.referenceImage.name{
                DispatchQueue.main.async {
                    self.tableView.isHidden = false
                }
                let alert = UIAlertController(title: imageName, message:"Noch funktioniert alles", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                
                let planeNode = erzeugeSCNNode.erzeugeSCNNode()
                
                //planeNode.position = SCNVector3(anchor.transform.columns.3.x, anchor.transform.columns.3.y, anchor.transform.columns.3.z)
                planeNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
                planeNode.localRotate(by: SCNQuaternion(x: 0, y: 0, z: 0.7071, w: 0.7071))
                
                planeNode.geometry?.firstMaterial?.diffuse.contents = tableView

                sceneView.scene.rootNode.addChildNode(planeNode)

            }
        }
    }
}
