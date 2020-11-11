//
//  ToastView.swift
//  ChatApp
//
//  Created by Mina Milosavljevic on 10/28/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func alertUserLoginError(message: String) {
        let alert = UIAlertController(title: "Woops",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss",
                                      style: .cancel, handler: nil))
        present(alert, animated: true)
    }

}

