//
//  LoginViewController.swift
//  Augmented Reality
//
//  Created by Marco Becker on 26.11.18.
//  Copyright © 2018 Marco Becker. All rights reserved.
//

import UIKit
import SVProgressHUD

// view controller to login users
class LoginViewController: UIViewController {
    
    private enum ViewControllerType{
        case home, login
    }
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // workaround to properly layout textfields
    override func viewDidLayoutSubviews() {
        UIUtility.configureTextFields(textFields: [mailTextField, passwordTextField])
        setTextFieldDelegates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        loginUser(email: mailTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
       performSegue(withIdentifier: "registerSegue", sender: nil)
    }
    
    
    private func loginUser(email: String, password: String){
        SVProgressHUD.show(withStatus: "Anmelden..")
        AuthenticationController.loginUser(withEmail: email, password: password) { (userId) in
            if let userId = userId{
                SVProgressHUD.dismiss()
                self.dismiss(animated: true, completion: nil)
                self.popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(self.popoverPresentationController!)
            }else{
                SVProgressHUD.dismiss()
            }
        }
    }
    
    private func setTextFieldDelegates(){
        mailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // hide keyboard when view controller is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension LoginViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
