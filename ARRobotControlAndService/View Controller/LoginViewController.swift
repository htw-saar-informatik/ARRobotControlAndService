//
//  LoginViewController.swift
//  Augmented Reality
//
//  Created by Marco Becker on 26.11.18.
//  Copyright © 2018 Marco Becker. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseAuth
import FirebaseMessaging

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
    
    var anzeigeStatusinformationen: [(key: String, value: String)] = []
    
    
    // workaround to properly layout textfields
    override func viewDidLayoutSubviews() {
        UIUtility.configureTextFields(textFields: [mailTextField, passwordTextField, registerMailTextField, registerPasswordTextField, registerPasswordRetypeField])
        setTextFieldDelegates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ladeStatusinformationen();
        
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
        
        if( registerPasswordTextField.text! == registerPasswordRetypeField.text!) {
            SVProgressHUD.show()
            
            Auth.auth().createUser(withEmail: registerMailTextField.text!, password: registerPasswordTextField.text!, completion: { (user, error) in
                if error == nil {
                    guard let user = user else{
                        NotificationUtility.showPrettyMessage(with: "Es ist ein Fehler aufgetreten", button: "ok", style: .error)
                        return
                    }
                    // sends a verification mail to the newly created user
                    user.user.sendEmailVerification(completion: nil)
                    let usr = User(id: user.user.uid, mail: self.registerMailTextField.text!)
                    usr.save();
                    
                    for (key, value) in self.anzeigeStatusinformationen {
                        FirebaseHelper.getDB().collection("user").document("\(usr.id)").collection("Config").document("\(key)").setData(["\(key)": true])
                        {
                            err in
                            if let err = err {
                                print(user.user.uid)
                                print("\(key)")
                            } else {
                            }
                        }
                    }
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
                    SVProgressHUD.dismiss()
                    
                    
                    
                }else {
                    if let errCode = AuthErrorCode(rawValue: error!._code) {
                        print(errCode)
                        switch errCode{
                        case .emailAlreadyInUse:
                            NotificationUtility.showPrettyMessage(with: "E-Mail Adresse bereits registriert", button: "ok", style: .error)
                            break
                        case .weakPassword:
                            NotificationUtility.showPrettyMessage(with: "Bitte wähle ein Passwort mit mindestens 6 Zeichen", button: "ok", style: .error)
                        default:
                            break
                        }
                    }
                    SVProgressHUD.dismiss()
                }
            })
        }
        else {
            NotificationUtility.showPrettyMessage(with: "Passwörter stimmen nicht überein", button: "ok", style: .success)
        }
    }
    
    
    
    
    private func loginUser(email: String, password: String){
        SVProgressHUD.show(withStatus: "Anmelden..")
        AuthenticationController.loginUser(withEmail: email, password: password) { (userId) in
            if let userId = userId{
                
                self.dismiss(animated: true, completion: nil)
                self.popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(self.popoverPresentationController!)
            }else{
                
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
    
    func ladeStatusinformationen(){
        FirebaseHelper.getDB().collection("config")
            .addSnapshotListener({
                querySnapshot, error in
                guard let snapshot = querySnapshot else {return}
                snapshot.documentChanges.forEach{
                    diff in
                    if diff.type == .added {
                        do {
                            let data = try JSONSerialization.data(withJSONObject: diff.document.data(), options: JSONSerialization.WritingOptions.prettyPrinted)
                            if let string = String(data: data, encoding: String.Encoding.utf8) {
                                self.anzeigeStatusinformationen.append((key: diff.document.documentID, value: string.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "").replacingOccurrences(of: "\(diff.document.documentID)", with: "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: ":", with: "").replacingOccurrences(of: " ", with: "")))
                            }
                            
                        } catch {
                            print(error)
                        }
                        
                    }
                }
            })
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
