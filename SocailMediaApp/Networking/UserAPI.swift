//
//  UserAPI.swift
//  SocailMediaApp
//
//  Created by Zahra Majed on 09/10/1443 AH.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserAPI {
    
    static func getUserData(userID:String, completionHandeler: @escaping (User) -> ()){
        AF.request("\(API.baseURL)/user/\(userID)", headers: API.headers).responseJSON { response in
            let jsonData = JSON(response.value!)
            let decoder = JSONDecoder()
            do {
                let user = try decoder.decode(User.self, from: jsonData.rawData())
                completionHandeler(user)
            } catch let error{
                print(error)
            }
        }
    }
    
    
    static func createUser(firstName: String, lastName: String, email: String, completionHandeler: @escaping (User?, String?) -> ()){
        
        let param = ["firstName" : firstName,
                     "lastName": lastName,
                     "email": email]
        //post request
        AF.request("\(API.baseURL)/user/create", method: .post, parameters: param, encoder: JSONParameterEncoder.default, headers: API.headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                let jsonData = JSON(response.value!)
                let decoder = JSONDecoder()
                do {
                    let user = try decoder.decode(User.self, from: jsonData.rawData())
                    completionHandeler(user, nil)
                } catch let error{
                    print(error)
                }
            case .failure(let error):
                let jsonData = JSON(response.data)
                let data = jsonData["data"]
                let emailError = data["email"].stringValue
                completionHandeler(nil, emailError)
            }
        }
    }
}
