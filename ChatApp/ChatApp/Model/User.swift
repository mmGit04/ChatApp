//
//  User.swift
//  ChatApp
//
//  Created by Mina Milosavljevic on 11/4/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import Foundation


struct UserData{
    let id: String
    var fullName:String?
    var email: String?
    
    public mutating func setupData(dict: [String: Any]) {
        fullName = dict["fullName"] as? String
        email = dict["email"] as? String
    }

}


