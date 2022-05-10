//
//  SigninViewController.swift
//  SocailMediaApp
//
//  Created by Zahra Majed on 09/10/1443 AH.
//

import UIKit

class SigninViewController: UIViewController {

    // MARK: OUTLETS
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: ACTIONS
    @IBAction func signinBtnClicked(_ sender: Any) {
        if let firstName = firstNameTxtField.text, let lastName = lastNameTxtField.text {
            if firstName.isEmpty || lastName.isEmpty {
                let alert = UIAlertController(title: "Error", message: "Please fill all fields", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                UserAPI.signinUser(firstName: firstName, lastName: lastName) { user, errorMsg in
                    if let msg = errorMsg {
                        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        if let loggedinUser = user {
                            let postVC = self.storyboard?.instantiateViewController(withIdentifier: "PostsViewController") as! PostsViewController
                            postVC.loggedinUser = loggedinUser
                            self.present(postVC, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
}
