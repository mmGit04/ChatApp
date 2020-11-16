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
    
    //private var documents: [DocumentSnapshot] = []
    public var currentLoggedInUser: UserData?
    
    let db = Firestore.firestore()
    
    public func addUser(uId: String?, userFullName: String?, email: String?) {
        
        guard let id = uId else {
            print("Value of user ID is nil.")
            return
        }
        checkIfDocumentExists(id: id) { (exists) in
            if !exists {
                self.db.collection("userData").document(id).setData([
                    "fullName": userFullName ?? "",
                    "email": email ?? ""
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(id)")
                    }
                }
            }
        }
        currentLoggedInUser = UserData(id: id, fullName: userFullName,email: email )
    }
    
    

    
    public func getAllUsers(completion: @escaping ([UserData], _: Bool) -> Void) {
        var resultData = [UserData]()
        let docRef = db.collection("userData")
        docRef.getDocuments { (querySnapshot, error) in
            for doc in querySnapshot!.documents {
                let id = doc.documentID
                let data = doc.data()
                var userData = UserData(id: id)
                userData.setupData(dict: data)
                resultData.append(userData)
            }
            if error != nil {
                completion(resultData, false )
            } else {
                completion(resultData, true)
            }
            
        }
        
    }
    
    private func checkIfDocumentExists(id: String, closure: @escaping (Bool) -> Void){
        let docRef = db.collection("userData").document(id)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                closure(true)
            } else {
                closure(false)
            }
        }
    }
    
//    public func getUserData(forEmail: String, completion: @escaping (User?, Bool) -> Void ) {
//
//        db.collection("user").whereField("email", isEqualTo: forEmail)
//            .getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                    completion(nil, false)
//                } else {
//                    var user: User?
//                    for document in querySnapshot!.documents {
//                        user = User(dictionary: document.data())
//                        print("\(document.documentID) => \(document.data())")
//                    }
//                    completion(user, true )
//                }
//        }
        
  //  }
}
