//
//  ViewController.swift
//  ChatApp
//
//  Created by Mina Milosavljevic on 10/28/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import JGProgressHUD
import FirebaseFirestore

class ViewController: UIViewController, GIDSignInDelegate, LoginButtonDelegate {
    
    // Outlets
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    // @IBOutlet weak var googleSignIn: GIDSignInButton!
    let facebookLoginButton = FBLoginButton()
    private let spinner = JGProgressHUD(style: .dark)
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        facebookLoginButton.delegate = self
    }
    
    //Facebook sign in
    @IBAction func registerWithFacebook(_ sender: UIButton) {
        facebookLoginButton.sendActions(for: .touchUpInside)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Logout")
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
                print("Error")
            }
            // Retrieve User Data
            
            
        }
    }
    
    // Sign in with email and password
    @IBAction func signInButtonPressed(_ sender: Any) {
        // Close the keyboards
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else {
            alertUserLoginError(message: "Please enter all information to log in.")
            return
        }
        
        spinner.show(in: view)
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            guard error == nil else {
                strongSelf.alertUserLoginError(message: "Failed to log in user with email: \(email)")
                return
            }
            // Retrieve data from this specific User and store in User Defaults
            DatabaseManager.instance.getUserData(forEmail: email) {(user, success) in
                if success {
                    UserDefaults.standard.setValue(user!.email, forKey: "email")
                    UserDefaults.standard.setValue(user!.fullName, forKey: "fullName")
                    print("Logged in a user: \(user!)")
                    strongSelf.performSegue(withIdentifier: "LoginToMainSegue", sender: strongSelf)
                }
            }
           
        }
        
    }
    
    @IBAction func googleSignIn(sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    
    // Google Sign in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if error != nil {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
                print("Error")
            }
        }
        
        func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
        
    }
    
    // MARK: Helpers
    
    func alertUserLoginError(message: String) {
        let alert = UIAlertController(title: "Woops",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss",
                                      style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
