//
//  PostTableViewCell.swift
//  SocailMediaApp
//
//  Created by Zahra Majed on 08/10/1443 AH.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    var tagsArray: [String] = []
    
    // MARK: OUTLETS
    @IBOutlet weak var userStackView: UIStackView! {
        didSet{
            userStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userStackViewTapped)))
        }
    }
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var postTxtLable: UILabel!
    @IBOutlet weak var postImgView: UIImageView!
    @IBOutlet weak var likesNumber: UILabel!
    @IBOutlet weak var tagsCollectionView: UICollectionView! {
        didSet{
            tagsCollectionView.delegate = self
            tagsCollectionView.dataSource = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: ACRIONS
    @objc func userStackViewTapped(){
        NotificationCenter.default.post(name: NSNotification.Name("userStackViewTapped"), object: nil, userInfo: ["cell": self])
    }

}

extension PostTableViewCell:UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagsInAllPostssCVCell", for: indexPath) as! tagsInAllPostssCVCell
        cell.tagLabel.text = tagsArray[indexPath.row]
        return cell
    }
    
    
}
