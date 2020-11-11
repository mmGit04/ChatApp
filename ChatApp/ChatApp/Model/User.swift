//
//  User.swift
//  ChatApp
//
//  Created by Mina Milosavljevic on 11/4/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import Foundation


struct User{
    var fullName:String
    var email: String
    
    var dictionary: [String: Any] {
        return [
            "fullName": fullName,
            
        ]
    }
}

extension User{
    init?(dictionary: [String : Any]) {
        guard  let name = dictionary["fullName"] as? String,
        let email = dictionary["email"] as? String
            else { return nil }
        
        self.init(fullName: name, email: email)
    }
}
