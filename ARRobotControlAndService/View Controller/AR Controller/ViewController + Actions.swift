//
//  ViewController + Actions.swift
//  ARRobotControlAndService
//
//  Created by Marco Becker on 15.12.18.
//  Copyright © 2018 Marco Becker. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

extension ViewController: UIPopoverPresentationControllerDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let popoverController = segue.destination.popoverPresentationController, let button = sender as? UIButton {
            popoverController.delegate = self
            popoverController.sourceView = button
            popoverController.sourceRect = button.bounds
        }
    }
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
       uiAnpassung()
    }
}
