//
//  erzeugeBrett.swift
//  ARRobotControlAndService
//
//  Created by Marco Becker on 07.12.18.
//  Copyright © 2018 Marco Becker. All rights reserved.
//

import Foundation
import ARKit

class ErzeugeSCNNode{
    let widthBigBox = CGFloat(0.5)
    let heightBigBox = CGFloat(0.75/2)
    let lengthBigBox = CGFloat(0.05)
    
    func erzeugeSCNNode(imageName:String) -> SCNNode{
        
        let tvPlane = SCNPlane(width: widthBigBox, height: heightBigBox)
        
        // auskommentiert, da probleme mit main thread
        tvPlane.firstMaterial?.isDoubleSided = true
        tvPlane.firstMaterial?.lightingModel = .constant
        
        //Erzeugt die verschiedene Elemente des Bildschirms
        let backgroundBox = SCNNode(geometry: SCNBox(width: widthBigBox, height: heightBigBox, length: lengthBigBox, chamferRadius: 0))
        backgroundBox.geometry?.firstMaterial?.diffuse.contents = UIColor.darkGray
        
        let frameLeft = SCNNode(geometry: SCNBox(width: 0.05, height: heightBigBox, length: 0.15, chamferRadius: 0))
        frameLeft.geometry?.firstMaterial?.diffuse.contents = UIColor.darkGray
        
        let frameRight = SCNNode(geometry: SCNBox(width: 0.05, height: heightBigBox, length: 0.15, chamferRadius: 0))
        frameRight.geometry?.firstMaterial?.diffuse.contents = UIColor.darkGray
        
        let frameUp = SCNNode(geometry: SCNBox(width: 0.6, height: 0.05, length: 0.15, chamferRadius: 0))
        frameUp.geometry?.firstMaterial?.diffuse.contents = UIColor.darkGray
        
        let frameDown = SCNNode(geometry: SCNBox(width: 0.6, height: 0.05, length: 0.15, chamferRadius: 0))
        frameDown.geometry?.firstMaterial?.diffuse.contents = UIColor.darkGray
        
        let tvPlaneNode = SCNNode()
        tvPlaneNode.geometry = SCNPlane()
        
        //Fügt die Elemente zusammen, so das sie ein Bildschirm ergeben
        frameDown.position = SCNVector3(0 , heightBigBox/2 + 0.025 , 0.025)
        frameUp.position = SCNVector3(0 , -heightBigBox/2 - 0.025 , 0.025)
        frameLeft.position = SCNVector3(-widthBigBox/2-0.025 , 0 , 0.025)
        frameRight.position = SCNVector3(widthBigBox/2+0.025 , 0 , 0.025)
        tvPlaneNode.position = SCNVector3(0,0,0.07)
        
        backgroundBox.addChildNode(tvPlaneNode)
        backgroundBox.addChildNode(frameLeft)
        backgroundBox.addChildNode(frameRight)
        backgroundBox.addChildNode(frameUp)
        backgroundBox.addChildNode(frameDown)
        
        return tvPlaneNode;
    }
    
}
