//
//  DatabaseManager.swift
//  ChatApp
//
//  Created by Mina Milosavljevic on 11/4/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseCore

class DatabaseManager {
    
    public static let instance = DatabaseManager()
    
    private var documents: [DocumentSnapshot] = []
    public var tasks: [User] = []
    private var listener : ListenerRegistration!
    let db = Firestore.firestore()
    
    public func addUser(user: User) {
        
        var docRef: DocumentReference? = nil
        docRef = db.collection("user").addDocument(data: [
            "fullName": user.fullName,
            "email": user.email
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(docRef!.documentID)")
            }
        }
    }
    
    public func getUserData(forEmail: String, completion: @escaping (User?, Bool) -> Void ) {
        
        db.collection("user").whereField("email", isEqualTo: forEmail)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(nil, false)
                } else {
                    var user: User?
                    for document in querySnapshot!.documents {
                         user = User(dictionary: document.data())
                        print("\(document.documentID) => \(document.data())")
                    }
                    completion(user, true )
                }
        }
        
    }
}
