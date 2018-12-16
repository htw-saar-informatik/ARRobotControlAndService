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
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var loginRegisterLabel: UILabel!
    @IBOutlet var loginRegisterButton: UIButton!
    
    
    
    @IBOutlet var registerMailTextField: UITextField!
    @IBOutlet var registerPasswordTextField: UITextField!
    @IBOutlet var registerPasswordRetypeField: UITextField!
    @IBOutlet var registerBackButton: UIButton!
    
    @IBOutlet var registerButton: RoundedButton!
    
    
    // workaround to properly layout textfields
    override func viewDidLayoutSubviews() {
        UIUtility.configureTextFields(textFields: [mailTextField, passwordTextField, registerMailTextField, registerPasswordTextField, registerPasswordRetypeField])
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
    
   
    @IBAction func loginRegisterButtonTapped(_ sender: Any) {
        mailTextField.isHidden = true
        passwordTextField.isHidden = true
        loginButton.isHidden = true
        loginRegisterLabel.isHidden = true
        loginRegisterButton.isHidden = true
        
        registerMailTextField.isHidden = false
        registerPasswordTextField.isHidden = false
        registerPasswordRetypeField.isHidden = false
        registerBackButton.isHidden = false
        registerButton.isHidden = false
    }
    
    @IBAction func registerBackButtonTapped(_ sender: Any) {
        mailTextField.isHidden = false
        passwordTextField.isHidden = false
        loginButton.isHidden = false
        loginRegisterLabel.isHidden = false
        loginRegisterButton.isHidden = false
        
        registerMailTextField.isHidden = true
        registerPasswordTextField.isHidden = true
        registerPasswordRetypeField.isHidden = true
        registerBackButton.isHidden = true
        registerButton.isHidden = true
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        SVProgressHUD.show()
        AuthenticationController.registerUser( email: mailTextField.text!, password: passwordTextField.text!) { (user) in
            if user != nil{
                SVProgressHUD.dismiss()
                NotificationUtility.showPrettyMessage(with: "Du hast dich erfolgreich registriert", button: "ok", style: .success)
                self.mailTextField.isHidden = false
                self.passwordTextField.isHidden = false
                self.loginButton.isHidden = false
                self.loginRegisterLabel.isHidden = false
                self.loginRegisterButton.isHidden = false
                
                self.registerMailTextField.isHidden = true
                self.registerPasswordTextField.isHidden = true
                self.registerPasswordRetypeField.isHidden = true
                self.registerBackButton.isHidden = true
                self.registerButton.isHidden = true
                
            }else{
                SVProgressHUD.dismiss()
            }
        }
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
        
        registerMailTextField.delegate = self
        registerPasswordTextField.delegate = self
        registerPasswordRetypeField.delegate = self
        
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
