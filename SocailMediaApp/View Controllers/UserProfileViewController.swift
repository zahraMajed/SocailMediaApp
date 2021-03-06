//
//  UserProfileViewController.swift
//  SocailMediaApp
//
//  Created by Zahra Majed on 09/10/1443 AH.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    var user: User!
    // MARK: OUTLETS
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var userCountryLabel: UILabel!
    @IBOutlet weak var userGenderLabel: UILabel!
    
    // MARK: LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.roundCorners([.topLeft, .topRight], radius: 30)
        setUserData()
    }
    
    // MARK: FUNCTIONS
   
    private func getOtherUserData(){
        UserAPI.getUserData(userID: user.id) { userResponse in
            self.user = userResponse
            self.setUserData()
        }
    }
    
    private func setUserData(){
        userNameLabel.text = user.firstName + " " + user.lastName
        if let userImg = user.picture {
            userImgView.setImageFromStringURL(stringURL: userImg)
        }
        userEmailLabel.text = user.email
        userPhoneLabel.text = user.phone
        userGenderLabel.text = user.gender
        if let location = user.location {
            userCountryLabel.text = location.city! + " , " + location.country!
        }
        getOtherUserData()
    }

}
