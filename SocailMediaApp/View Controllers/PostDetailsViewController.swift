//
//  PostDetailsViewController.swift
//  SocailMediaApp
//
//  Created by Zahra Majed on 08/10/1443 AH.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class PostDetailsViewController: UIViewController {
    //here i set 3 image
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
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    
    // MARK: LIFE CYCLE METHOD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        loaderView.startAnimating()
        setPostData()
        
    }
    
    // MARK: ACTION
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: FUNCTIONS
    private func setPostData(){
        userNameLbl.text = post.owner.firstName + " " + post.owner.lastName
        postTxtLbl.text = post.text
        likesNumberLbl.text = String(post.likes)
        postImgView.setImageFromStringURL(stringURL: post.image)
        userImgview.makeCircularImg()
        userImgview.setImageFromStringURL(stringURL: post.owner.picture)
        getPostComments()
    }
    
    private func getPostComments(){
        let url = "https://dummyapi.io/data/v1/post/\(post.id)/comment"
        let appId = "6278eb012721ec3f09a86f0f"
        let headers: HTTPHeaders = [
            "app-id": appId,
        ]

        AF.request(url, headers: headers).responseJSON { response in
            self.loaderView.stopAnimating()
            let jsonData = JSON(response.value!)
            let data = jsonData["data"]
            let decoder = JSONDecoder()
            do {
                self.commentsArray = try decoder.decode([Comments].self, from: data.rawData())
                self.commentsTableView.reloadData()
            } catch let Error{
                print(Error)
            }
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
        cell.userNameLabel.text = currentComment.owner.firstName + " " + currentComment.owner.firstName
        cell.commentMsgLabel.text = currentComment.message
        
        cell.userImgView.makeCircularImg()
        
        if let imgURL = URL(string: currentComment.owner.picture) {
            if let imgData = try? Data(contentsOf: imgURL){
                cell.userImgView.image = UIImage(data: imgData)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
}
