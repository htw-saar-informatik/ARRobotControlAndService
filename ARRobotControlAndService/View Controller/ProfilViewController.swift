//
//  ProfilViewController.swift
//  ARRobotControlAndService
//
//  Created by Marco Becker on 07.12.18.
//  Copyright © 2018 Marco Becker. All rights reserved.
//

import UIKit

class ProfilViewController: UIViewController {

    
    @IBOutlet var eMailLabel: UILabel!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var passwordButton: UIButton!
    var anzeige: Bool = false;
    var saveUserID: String = ""
    var savedEMail: String = ""
    var savedPassword: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            let loginType = userInformation["type"] as! String
            if loginType == "mail"{
                saveUserID = userInformation["userid"] as! String
                savedEMail = userInformation["email"] as! String
                savedPassword = userInformation["password"] as! String
        
            }
        }
        
        eMailLabel.text = savedEMail;
        passwordLabel.text = savedPassword;
        
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
    
    
    
    @IBAction func passwordButtonTapped(_ sender: Any) {
        if(anzeige == false) {
            passwordLabel.isHidden=false
            anzeige = true;
            passwordButton.setTitle("Passwort ausblenden", for: .normal);
        }
        else {
            passwordLabel.isHidden = true;
            anzeige = false;
            passwordButton.setTitle("Passwort anzeigen", for: .normal);
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

