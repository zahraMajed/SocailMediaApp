//
//  NewPostViewController.swift
//  SocailMediaApp
//
//  Created by Zahra Majed on 11/10/1443 AH.
//

import UIKit
import NVActivityIndicatorView

class NewPostViewController: UIViewController {
    
    
    // MARK: OUTLETS
    @IBOutlet weak var postTextTF: UITextField!
    @IBOutlet weak var postImgTF: UITextField!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    
    // MARK: LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: ACTIONS
    @IBAction func newPostBtnClicked(_ sender: Any) {
        if  let user = UserManager.loggedinUser  {
            loaderView.startAnimating()
            if let postText = postTextTF.text {
                if postText.isEmpty {
                    let alert = UIAlertController(title: "Error", message: "Please fill all fields", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    PostAPI.addNewPst(userID: user.id, text: postText, imgUrl: postImgTF.text!) {
                        self.loaderView.stopAnimating()
                        NotificationCenter.default.post(name: Notification.Name("NewPostAdded"), object: nil, userInfo: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    @IBAction func backBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
  
}
