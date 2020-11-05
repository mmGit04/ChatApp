//
//  MainViewController.swift
//  ChatApp
//
//  Created by Mina Milosavljevic on 11/3/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource {
    
    private var data = [String:String]()

    // Outlets
    @IBOutlet weak var dataTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        dataTableView.tableFooterView = UIView()
        dataTableView.dataSource = self
    }
    
    private func loadData() {
        let fullName = UserDefaults.standard.string(forKey: "fullName")
        let email = UserDefaults.standard.string(forKey: "email")
        data["fullName"] = fullName
        data["email"] = email
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



}
