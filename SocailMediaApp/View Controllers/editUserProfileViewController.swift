//
//  editUserProfileViewController.swift
//  SocailMediaApp
//
//  Created by Zahra Majed on 12/10/1443 AH.
//

import UIKit
import NVActivityIndicatorView

class editUserProfileViewController: UIViewController {
    
    // MARK: OUTLETS
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var imgUrlTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var backView: UIView!
    
    // MARK: LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.roundCorners([.topLeft, .topRight], radius: 30)
        setupUI()
    }

    //MARK: ACTIONS
    @IBAction func updateBtnClicked(_ sender: Any) {
        guard let loggedInUser = UserManager.loggedinUser else {
            return
        }
        loaderView.startAnimating()
        UserAPI.updateUser(userId: loggedInUser.id, firstName: firstNameTF.text!,lastName: lastNameTF.text!, phone: phoneTF.text!, imgUrl: imgUrlTF.text!) { userRes, error in
            self.loaderView.stopAnimating()
            if let user = userRes {
                if let img = user.picture {
                    self.userImg.setImageFromStringURL(stringURL: img)
                }
                self.userNameLabel.text = user.firstName + " " + user.lastName
            }
        }
    }
    
    //MARK: FUNCTION
    private func setupUI(){
        if let user = UserManager.loggedinUser {
            if let img = user.picture {
                userImg.setImageFromStringURL(stringURL: img)
            }
            userNameLabel.text = user.firstName + " " + user.lastName
        }
    }
    
}
