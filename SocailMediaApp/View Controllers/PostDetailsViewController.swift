//
//  PostDetailsViewController.swift
//  SocailMediaApp
//
//  Created by Zahra Majed on 08/10/1443 AH.
//

import UIKit
import NVActivityIndicatorView

class PostDetailsViewController: UIViewController {
    
    // MARK: VARIABLES
    var post: Post!
    var commentsArray: [Comments] = []
    
    // MARK: OUTLETS
    @IBOutlet weak var userImgview: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var postTxtLbl: UILabel!
    @IBOutlet weak var postImgView: UIImageView!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var likesNumberLbl: UILabel!
    @IBOutlet weak var commentTxtField: UITextField!
    @IBOutlet weak var newCommentStackView: UIStackView!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    
    // MARK: LIFE CYCLE METHOD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        loaderView.startAnimating()
        setPostData()
        checkIfUserOrGuest()
        
    }
    
    // MARK: ACTION
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendCommentBtnClicked(_ sender: Any) {
        let msg = commentTxtField.text!
        if let loggedUser = UserManager.loggedinUser{
            PostAPI.addNewCommentToPst(postId: post.id, userID: loggedUser.id, msg: msg) {
                self.getPostComments()
                self.commentTxtField.text?.removeAll()
            }
        }
    }
    
    // MARK: FUNCTIONS
    private func checkIfUserOrGuest(){
        if UserManager.loggedinUser == nil {
            newCommentStackView.isHidden = true
        }else{
            newCommentStackView.isHidden = false
        }
    }

    private func setPostData(){
        userNameLbl.text = post.owner.firstName + " " + post.owner.lastName
        postTxtLbl.text = post.text
        likesNumberLbl.text = String(post.likes)
        postImgView.setImageFromStringURL(stringURL: post.image)
        userImgview.makeCircularImg()
        userImgview.setImageFromStringURL(stringURL: post.owner.picture!)
        getPostComments()
    }
    
    private func getPostComments(){
        PostAPI.getPostComments(postID: post.id) { commentsArrayResponse in
            self.commentsArray = commentsArrayResponse
            self.commentsTableView.reloadData()
            self.loaderView.stopAnimating()
        }
    }
}

// MARK: TABLE VIEW PROTOCOLS

extension PostDetailsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell") as! CommentsTableViewCell
        let currentComment = commentsArray[indexPath.row]
        cell.userNameLabel.text = currentComment.owner.firstName + " " + currentComment.owner.lastName
        cell.commentMsgLabel.text = currentComment.message
        
        cell.userImgView.makeCircularImg()
        
        if let userImg = currentComment.owner.picture {
            cell.userImgView.setImageFromStringURL(stringURL: userImg)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
}
