//
//  users.swift
//  SocailMediaApp
//
//  Created by Zahra Majed on 08/10/1443 AH.
//

import Foundation
import UIKit


struct User : Decodable {
    var id: String
    var firstName: String
    var lastName: String
    var picture: String
}
