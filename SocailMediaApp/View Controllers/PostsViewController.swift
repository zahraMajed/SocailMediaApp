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
    var selectedTag:String?
    var pageNum = 0
    var totalNum = 0
    
    // MARK: OUTLETS
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var postTagLabel: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var newPostcontainer: UIView!
    
    // MARK: LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsTableView.delegate = self
        postsTableView.dataSource = self
        loaderView.startAnimating()
        checkIfUserOrGuest()
        checkIfTag()
        getPosts()
        
        newPostcontainer.roundCorners(.allCorners, radius: 30)
        NotificationCenter.default.addObserver(self, selector: #selector(userProfileTapped), name: NSNotification.Name(rawValue: "userStackViewTapped"), object: nil)
       
        NotificationCenter.default.addObserver(self, selector: #selector(newPostAdded), name: NSNotification.Name(rawValue: "NewPostAdded"), object: nil)
        
    }
    
    // MARK: ACTIONS
    @IBAction func colseBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: FUNCTIONS
    private func checkIfUserOrGuest(){
        if  UserManager.loggedinUser != nil {
            signinBtn.setImage(UIImage(systemName: "lock"), for: .normal)
            newPostcontainer.isHidden = false
        }else{
            signinBtn.setImage(UIImage(systemName: "lock.open"), for: .normal)
            newPostcontainer.isHidden = true
        }
    }
    private func checkIfTag(){
        if let selectedTag = selectedTag {
            postTagLabel.text = selectedTag.trimmingCharacters(in: .whitespaces).capitalizingFirstLetter()
            closeBtn.isHidden = false
        } else {
            postTagLabel.text = "Feed"
            closeBtn.isHidden = true
            
        }
    }
    private func getPosts(){
        PostAPI.getAllPosts(page: pageNum, tag: selectedTag) { postsArrayResponse, total in
            self.postsArray.append(contentsOf: postsArrayResponse)
            self.postsTableView.reloadData()
            self.totalNum = total
            self.loaderView.stopAnimating()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signoutSeg" {
            UserManager.loggedinUser = nil
        }
    }
    
    // MARK: OBJC FUNCTIONS
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
    
    @objc func newPostAdded(){
        loaderView.startAnimating()
        postsArray = []
        pageNum = 0
        getPosts()
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
        if let postImg = currentPost.owner.picture {
            cell.userImgView.setImageFromStringURL(stringURL: postImg)
        }
        cell.userNameLabel.text = currentPost.owner.firstName + " " + currentPost.owner.lastName
        cell.postTxtLable.text = currentPost.text
        cell.postImgView.setImageFromStringURL(stringURL: currentPost.image)
        cell.likesNumber.text = String(currentPost.likes)
        cell.tagsArray = currentPost.tags ?? []
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postsTableView.deselectRow(at: indexPath, animated: true)
        let selectedPost = postsArray[indexPath.row]
        let postDetailsVC = storyboard?.instantiateViewController(withIdentifier: "PostDetailsViewController") as! PostDetailsViewController
        postDetailsVC.post = selectedPost
        present(postDetailsVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if indexPath.row == postsArray.count - 1 && postsArray.count < totalNum {
                pageNum = pageNum + 1
                getPosts()
            }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 465
    }
    
    
}
