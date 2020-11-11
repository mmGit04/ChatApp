//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by Mina Milosavljevic on 10/28/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    // Outlets
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var repeatPassTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    private let spinner = JGProgressHUD(style: .dark)
    var emailAlreadyInUse: Bool = true
    var vSpinner : UIView?
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if Auth.auth().currentUser != nil {
                self.performSegue(withIdentifier: "RegisterToMainSegue", sender: nil)
            }
        }
    }
    
    private func updateUserInfo(displayName: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        changeRequest?.commitChanges { (error) in
            print("Error saving user name to Firebase user object.")
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        fullNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        repeatPassTextField.resignFirstResponder()
        
        // Data validation
        let (valid, message) = validateLoginForm()
        if !valid {
            self.alertUserLoginError(message: message!)
            return
        }
        
        spinner.show(in: view)
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
            
            DispatchQueue.main.async {
                self.spinner.dismiss()
            }
            
            guard let _ = authResult?.user, error == nil else {
                if let err = error {
                    let nsError = err as NSError
                    switch nsError.code {
                    case AuthErrorCode.emailAlreadyInUse.rawValue: //<- Your Error
                        self.alertUserLoginError(message: "User with this email is already registered.")
                    default:
                        self.alertUserLoginError(message: "Error registering the user")
                    }
                }
                return
            }
            // User is registered succesfully
            UserDefaults.standard.set(true, forKey: "isLogin")
            print("User is registered succesfully")
            self.updateUserInfo(displayName: self.fullNameTextField.text!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case fullNameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            repeatPassTextField.becomeFirstResponder()
        default:
            repeatPassTextField.resignFirstResponder()
        }
        return true
    }
    
    // MARK: Validation
    private func validate(_ textField: UITextField) -> (Bool, String?) {
        guard let text = textField.text else {
            return (false, nil)
        }
        switch textField {
        case fullNameTextField:
            return (!text.isEmpty, "Name cannot be empty.")
        case emailTextField:
            return (!text.isEmpty, "Email cannot be empty.")
        case passwordTextField:
            return (text.count > 4, "Minimal password lenght is 5.")
        case repeatPassTextField:
            return (text == passwordTextField.text!, "Repeated password doesn't match password.")
        default: return (false, "Error")
        }
    }
    
    private func validateLoginForm() -> (Bool, String?) {
        var result: (valid: Bool, message: String?)
        result = validate(fullNameTextField)
        guard result.valid else { return result }
        result = validate(emailTextField)
        guard result.valid else { return result }
        result = validate(passwordTextField)
        guard result.valid else { return result }
        return validate(repeatPassTextField)
    }
}




