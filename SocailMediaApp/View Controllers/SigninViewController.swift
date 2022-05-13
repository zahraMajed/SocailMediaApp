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
    
    // MARK: LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func addAddPostTap(){
        let mainTabBar = self.storyboard?.instantiateViewController(withIdentifier: "MainTapBar") as! UITabBarController
        let vc1 = PostsViewController()
        let vc2 = NewPostViewController()
        let vc3 = PostDetailsViewController()
        mainTabBar.setViewControllers([vc1,vc2,vc3], animated: true)
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
                            let postVC = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBar")
                            UserManager.loggedinUser = loggedinUser
                            self.present(postVC!, animated: true, completion: nil)
                         
                        }
                    }
                }
            }
        }
    }
    
}
