//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by Mina Milosavljevic on 10/28/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    // Outlets
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var repeatPassTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Variables
    let datePicker = UIDatePicker()
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    
    var emailAlreadyInUse: Bool = true
    var vSpinner : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
    }
    
    private func setupDatePicker() {
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        toolbar.setItems([doneButton], animated: false)
        birthdayTextField.inputAccessoryView = toolbar
        datePicker.datePickerMode = .date
        datePicker.setDatePickerValidation(min: 10, max: 80)
        birthdayTextField.inputView = datePicker
        birthdayTextField.text = formatter.string(from: datePicker.date)
    }
    
    @objc func doneDatePicker(){
        birthdayTextField.text = formatter.string(from: datePicker.date)
        emailTextField.becomeFirstResponder()
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        let (valid, message) = validateLoginForm()
        if !valid {
            showToast(message: message!, font: .systemFont(ofSize: 18.0))
            return
        }
        showSpinner(onView: view)
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
            self.removeSpinner()
            if let x = error {
                let err = x as NSError
                switch err.code {
                case AuthErrorCode.emailAlreadyInUse.rawValue: //<- Your Error
                    self.showToast(message: "User with this email is already registered.", font: .systemFont(ofSize: 18.0))
                default:
                    self.showToast(message: "Error registering the user", font: .systemFont(ofSize: 18.0))
                }
                
            } else {
                self.performSegue(withIdentifier: "RegisterToMainSegue", sender: nil)
            }
            
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case fullNameTextField:
            birthdayTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            repeatPassTextField.becomeFirstResponder()
        default:
            repeatPassTextField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (textField == birthdayTextField) {
            birthdayTextField.text = formatter.string(from: datePicker.date)
        }
        
        return true
    }
    // MARK: Helpers
    private func validate(_ textField: UITextField) -> (Bool, String?) {
        guard let text = textField.text else {
            return (false, nil)
        }
        switch textField {
        case fullNameTextField:
            return (text.count > 0, "Name cannot be empty.")
        case emailTextField:
            return (text.count > 0, "Email cannot be empty.")
        case passwordTextField:
            return (text.count > 4, "Minimal password lenght is 5.")
        case repeatPassTextField:
            return (text == passwordTextField.text!, "Repeated password doesn't match password.")
        default: return (false, "Error")
        }
    }
    
    private func validateLoginForm() -> (Bool, String?) {
        var result: (valid: Bool, message: String?)
        result = validate(fullNameTextField)
        guard result.valid else { return result }
        result = validate(emailTextField)
        guard result.valid else { return result }
        result = validate(passwordTextField)
        guard result.valid else { return result }
        return validate(repeatPassTextField)
    }
}

extension UIDatePicker {
    func setDatePickerValidation(min: Int, max: Int) {
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -min
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = -max
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        self.minimumDate = minDate
        self.maximumDate = maxDate
    } }


extension RegisterViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
}
