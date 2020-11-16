//
//  SearchViewController.swift
//  ChatApp
//
//  Created by Mina Milosavljevic on 11/11/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var searchResult = [UserData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        resultTableView.dataSource = self
        resultTableView.tableFooterView = UIView()
        searchBar.becomeFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        filterUsersByName(searchCriteria: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: Search helpers
    private func filterUsersByName(searchCriteria: String) {
        DatabaseManager.instance.getAllUsers(completion: { (usersData, success) in
            // Empty search result before setting new value
            self.searchResult = []
            for user in usersData {
                if let name = user.fullName, let _ = name.range(of: searchCriteria, options: .caseInsensitive) {
                    self.searchResult.append(user)
                }
            }
            self.resultTableView.reloadData()
        })
        
    }
    
    // MARK: Table View data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultTableView.dequeueReusableCell(withIdentifier: "searchCell") as! SearchTableViewCell
        let result = searchResult[indexPath.row]
        cell.setupCell(name: result.fullName ?? "")
        return cell
    }
}
