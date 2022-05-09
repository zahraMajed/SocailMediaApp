//
//  PostTableViewCell.swift
//  SocailMediaApp
//
//  Created by Zahra Majed on 08/10/1443 AH.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var postTxtLable: UILabel!
    @IBOutlet weak var postImgView: UIImageView!
    @IBOutlet weak var likesNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
