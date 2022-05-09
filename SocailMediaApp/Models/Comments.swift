//
//  Comments.swift
//  SocailMediaApp
//
//  Created by Zahra Majed on 08/10/1443 AH.
//

import Foundation
import UIKit


struct Comments : Decodable {
    var id: String
    var message: String
    var owner: User
}
