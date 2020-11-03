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

class ViewController: UIViewController, GIDSignInDelegate, LoginButtonDelegate {
    
    // Outlets
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    // @IBOutlet weak var googleSignIn: GIDSignInButton!
    let facebookLoginButton = FBLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        facebookLoginButton.delegate = self
        
    }
    
    
    private func addFBbutton() {
        //        let loginButton = FBLoginButton()
        //        loginButton.translatesAutoresizingMaskIntoConstraints = false
        //        view.addSubview(loginButton)
        //        NSLayoutConstraint.activate([
        //            loginButton.leadingAnchor.constraint(equalTo: googleSignIn.trailingAnchor, constant: 30),
        //            loginButton.centerYAnchor.constraint(equalTo: googleSignIn.centerYAnchor),
        //            loginButton.widthAnchor.constraint(equalToConstant: 150),
        //            loginButton.heightAnchor.constraint(equalToConstant: 50)
        //        ])
        //        loginButton.delegate = self
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
            
            
        }
    }
    
    // Sign in with email and password
    @IBAction func signInButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text else {
            return
        }
        guard let password = passwordTextField.text else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            print(error)
            
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
}
