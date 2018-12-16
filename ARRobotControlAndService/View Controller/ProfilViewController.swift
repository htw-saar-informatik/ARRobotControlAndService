//
//  ProfilViewController.swift
//  ARRobotControlAndService
//
//  Created by Marco Becker on 07.12.18.
//  Copyright © 2018 Marco Becker. All rights reserved.
//

import UIKit

class ProfilViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
    }
    
    // triggered when logout button is tapped
    // logs the current user out and stops listening for notifications
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        AuthenticationController.logOutUser { (success) in
            if success{
                self.dismiss(animated: true, completion: nil)
                 self.popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(self.popoverPresentationController!)
            }
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

