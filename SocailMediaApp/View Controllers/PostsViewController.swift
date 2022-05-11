//
//  ViewController.swift
//  SocailMediaApp
//
//  Created by Zahra Majed on 08/10/1443 AH.
//

import UIKit
import NVActivityIndicatorView

class PostsViewController: UIViewController {
    
    var postsArray: [Post] = []
    var loggedinUser: User?
    
    // MARK: OUTLETS
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var signinBtn: UIButton!
    
    // MARK: LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsTableView.delegate = self
        postsTableView.dataSource = self
        loaderView.startAnimating()
        checkIfUserOrGuest()
        getPosts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(userProfileTapped), name: NSNotification.Name(rawValue: "userStackViewTapped"), object: nil)
        
    }
    
    // MARK: FUNCTIONS
    
    private func checkIfUserOrGuest(){
        if loggedinUser != nil {
            signinBtn.titleLabel?.text = "Signout"
        }else{
            signinBtn.titleLabel?.text = "Signin"
        }
    }
    private func getPosts(){
        PostAPI.getAllPosts { postsArrayResponse in
            self.postsArray = postsArrayResponse
            self.postsTableView.reloadData()
            self.loaderView.stopAnimating()
        }
    }
    
    @objc func userProfileTapped(notification: Notification){
        if let cell = notification.userInfo?["cell"] as? PostTableViewCell {
            if let tappedPostIndexPath = postsTableView.indexPath(for: cell){
                let tappedPost = postsArray[tappedPostIndexPath.row]
                let UserProfileVC = storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
                UserProfileVC.user = tappedPost.owner
                present(UserProfileVC, animated: true, completion: nil)
            }
        }
        
    }
}

// MARK: TABLE VIEW METHODS
extension PostsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        let currentPost = postsArray[indexPath.row]
        //filling data
        cell.userImgView.makeCircularImg()
        cell.userImgView.setImageFromStringURL(stringURL: currentPost.owner.picture!)
        cell.userNameLabel.text = currentPost.owner.firstName + " " + currentPost.owner.lastName
        cell.postTxtLable.text = currentPost.text
        cell.postImgView.setImageFromStringURL(stringURL: currentPost.image)
        cell.likesNumber.text = String(currentPost.likes)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postsTableView.deselectRow(at: indexPath, animated: true)
        let selectedPost = postsArray[indexPath.row]
        let postDetailsVC = storyboard?.instantiateViewController(withIdentifier: "PostDetailsViewController") as! PostDetailsViewController
        postDetailsVC.post = selectedPost
        postDetailsVC.loggedUser = loggedinUser
        present(postDetailsVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 425
    }
    
    
}



