//
//  UIimage+StringURLToImage.swift
//  SocailMediaApp
//
//  Created by Zahra Majed on 09/10/1443 AH.
//

import Foundation
import UIKit

extension UIImageView {
    func setImageFromStringURL(stringURL: String){
        if let imgURL = URL(string: stringURL) {
            if let imgData = try? Data(contentsOf: imgURL){
                self.image = UIImage(data: imgData)
            }
        }
    }
    
    func makeCircularImg(){
        self.layer.cornerRadius = self.frame.width / 2
    }
}
