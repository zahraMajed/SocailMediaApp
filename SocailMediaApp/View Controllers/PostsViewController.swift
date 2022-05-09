//
//  ViewController.swift
//  SocailMediaApp
//
//  Created by Zahra Majed on 08/10/1443 AH.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class PostsViewController: UIViewController {

    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var postsTableView: UITableView!
    var postsArray: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsTableView.delegate = self
        postsTableView.dataSource = self
        loaderView.startAnimating()
        getPosts()
    }
    
    private func getPosts(){
        let url = "https://dummyapi.io/data/v1/post"
        let appId = "6278eb012721ec3f09a86f0f"
        let headers: HTTPHeaders = [
            "app-id": appId,
        ]

        AF.request(url, headers: headers).responseJSON { response in
            self.loaderView.stopAnimating()
            let jsonData = JSON(response.value!)
            let data = jsonData["data"]
            //Now convert json to struct (valid format in swift)
            let decoder = JSONDecoder()
            do {
                self.postsArray = try decoder.decode([Post].self, from: data.rawData())
                self.postsTableView.reloadData()
            } catch let Error{
                print(Error)
            }
        }
    }
}

extension PostsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        let currentPost = postsArray[indexPath.row]
        //filling data
        cell.userImgView.makeCircularImg()
        cell.userImgView.setImageFromStringURL(stringURL: currentPost.owner.picture)
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
        present(postDetailsVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 425
    }
    
    
}



