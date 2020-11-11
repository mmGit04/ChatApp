//
//  MainViewController.swift
//  ChatApp
//
//  Created by Mina Milosavljevic on 11/3/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class ProfileViewController: UIViewController, UITableViewDataSource {
    
    // Variables
    private var data = [String:String]()
    var handle: AuthStateDidChangeListenerHandle?
    
    // Outlets
    @IBOutlet weak var dataTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        dataTableView.tableFooterView = UIView()
        dataTableView.dataSource = self
    }
    
    private func loadData() {
        let user = Auth.auth().currentUser
        if let user = user {
            let fullName = user.displayName ?? ""
            let email = user.email
            data["fullName"] = fullName
            data["email"] = email
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if Auth.auth().currentUser == nil {
                self.performSegue(withIdentifier: "returnToLoginSegue", sender: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    // MARK: Table View Data Source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dataTableView.dequeueReusableCell(withIdentifier: "profileCell") as! ProfileViewCell
        switch indexPath.row {
        case 0:
            cell.setupCell(title: "User name", detail: data["fullName"]!)
        case 1:
            cell.setupCell(title: "Email", detail: data["email"]!)
        default:
            break
        }
        return cell
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            UserDefaults.standard.set(false, forKey: "isLogin")
            AccessToken.current=nil
            
            print("Succesfully logout.")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
