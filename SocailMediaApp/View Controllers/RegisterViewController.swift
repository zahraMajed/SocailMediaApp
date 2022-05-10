//
//  RegisterViewController.swift
//  SocailMediaApp
//
//  Created by Zahra Majed on 09/10/1443 AH.
//

import UIKit

class RegisterViewController: UIViewController {

    // MARK: OUTLETS
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    
    // MARK: LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: ACTIONS
    @IBAction func signupBtnClicked(_ sender: Any) {
        if let firstName = firstNameTxtField.text, let lastName = lastNameTxtField.text, let email = emailTxtField.text {
            if firstName.isEmpty || lastName.isEmpty || email.isEmpty  {
                let alert = UIAlertController(title: "Error", message: "Please fill all fields", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }else {
                UserAPI.createUser(firstName: firstName, lastName: lastName, email: email) { user, errorMsg in
                    if errorMsg != nil {
                        let alert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Success", message: "User Created", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }

}
