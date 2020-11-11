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

class LoginViewController: UIViewController, GIDSignInDelegate, LoginButtonDelegate {
    
    // Outlets
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    // Variables
    let facebookLoginButton = FBLoginButton()
    private let spinner = JGProgressHUD(style: .dark)
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        facebookLoginButton.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let _ = Auth.auth().currentUser {
                UserDefaults.standard.set(true, forKey: "isLogin")
                self.performSegue(withIdentifier: "LoginToMainSegue", sender: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    // MARK: Facebook sign in
    @IBAction func registerWithFacebook(_ sender: UIButton) {
        facebookLoginButton.sendActions(for: .touchUpInside)
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard error == nil else {
            self.alertUserLoginError(message: "Failed to log in user with facebook.")
            return
        }
        if let canceled = result?.isCancelled, canceled {
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            guard error == nil else {
                self.alertUserLoginError(message: "Failed to log in user with facebook.")
                print("Error while signing in facebook user.")
                return
            }
            // Succesfully logged in
            print("Logged in with facebooka account.")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("FB logout")
    }
    
    // MARK: Sign in with email and password
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
            // Succesfully logged in
            print("Logged in a user with email : \(email)")
        }
        
    }
    
    // MARK: Sign In with google
    @IBAction func googleSignIn(sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    // Google Sign in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        guard error == nil else {
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            guard error == nil else {
                self.alertUserLoginError(message: "Failed to log in user with google.")
                print("Error while signing in google user.")
                return
            }
            // Succesfully logged in
            print("Logged in with google account.")
        }
    }
    
}
