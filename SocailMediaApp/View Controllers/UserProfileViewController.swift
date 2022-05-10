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
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var userCountryLabel: UILabel!
    @IBOutlet weak var userGenderLabel: UILabel!
    
    // MARK: LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
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
        userImgView.setImageFromStringURL(stringURL: user.picture!)
        userImgView.makeCircularImg()
        userEmailLabel.text = user.email
        userPhoneLabel.text = user.phone
        userGenderLabel.text = user.gender
        if let location = user.location {
            userCountryLabel.text = location.city! + " , " + location.country!
        }
        getOtherUserData()
    }

}
