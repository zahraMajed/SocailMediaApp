//
//  TagsViewController.swift
//  SocailMediaApp
//
//  Created by Zahra Majed on 10/10/1443 AH.
//

import UIKit
import NVActivityIndicatorView

class TagsViewController: UIViewController {
    
    var tagsArray: [String] = []
    
    // MARK: OUTLETS
    @IBOutlet weak var tagsCollectionV: UICollectionView!
    @IBOutlet weak var sigininBtn: UIButton!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    
    // MARK: LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        tagsCollectionV.delegate = self
        tagsCollectionV.dataSource = self
        checkIfUserOrGuest()
        getTags()
    }
    
    // MARK: FUNCTION
    private func getTags(){
        loaderView.startAnimating()
        PostAPI.getAllTags { tagsArrayRes in
            self.loaderView.stopAnimating()
            self.tagsArray = tagsArrayRes
            self.tagsCollectionV.reloadData()
        }
    }
    private func checkIfUserOrGuest(){
        if  UserManager.loggedinUser != nil {
            sigininBtn.setImage(UIImage(systemName: "lock"), for: .normal)
        }else{
            sigininBtn.setImage(UIImage(systemName: "lock.open"), for: .normal)
        }
    }
    
    


}

// MARK: COLLECTION VIEW FUNCTIONS
extension TagsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagsCVCell", for: indexPath) as! tagsCVCell
        let currentTag = tagsArray[indexPath.row]
        cell.tagLabel.text = currentTag
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTag = tagsArray[indexPath.row]
        let postVC = storyboard?.instantiateViewController(withIdentifier: "PostsViewController") as! PostsViewController
        postVC.selectedTag = selectedTag
        present(postVC, animated: true, completion: nil)
    }
    
    
}
