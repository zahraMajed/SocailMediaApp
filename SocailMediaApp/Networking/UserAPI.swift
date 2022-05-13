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
    
    //MARK: GET USER DATA
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
    
    // MARK: CRATE USER
    static func createUser(firstName: String, lastName: String, email: String, completionHandeler: @escaping (User?, String?) -> ()){
        
        //if body parameter use: JSONParameterEncoder
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
                
                //error msg
                let emailError = data["email"].stringValue
                let firstNameError = data["firstName"].stringValue
                let lastNameError = data["lastName"].stringValue
                let errorMsg = emailError + " " + firstNameError + " " + lastNameError
                
                completionHandeler(nil, errorMsg)
            }
        }
    }
    
    // MARK: SIGININ USER
    static func signinUser(firstName: String, lastName: String, completionHandeler: @escaping (User?, String?) -> ()){
        //if query parameter use: URLEncodedFormParameterEncoder
        let param = ["created" : 1 ]
        //post request
        AF.request("\(API.baseURL)/user", method: .get, parameters: param, encoder: URLEncodedFormParameterEncoder.default, headers: API.headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                let jsonData = JSON(response.value!)
                let data = jsonData["data"]
                let decoder = JSONDecoder()
                do {
                    let usersArray = try decoder.decode([User].self, from: data.rawData())
                    
                    var userIsFound = false
                    var foundUser: User?
                    for user in usersArray {
                        if user.firstName == firstName && user.lastName == lastName {
                            userIsFound = true
                            foundUser = user
                            break
                        }
                    }
                    if let foundUser = foundUser {
                        completionHandeler(foundUser,nil)
                    } else {
                        completionHandeler(nil, "First or last name doesn't match any user")
                    }
                } catch let error{
                    print(error)
                }
            case .failure(let error):
                let jsonData = JSON(response.data)
                let data = jsonData["data"]
                
                //error msg
                let emailError = data["email"].stringValue
                let firstNameError = data["firstName"].stringValue
                let lastNameError = data["lastName"].stringValue
                let errorMsg = emailError + " " + firstNameError + " " + lastNameError
                completionHandeler(nil, errorMsg)
            }
        }
    }
    
    // MARK: UPDATE USER
    static func updateUser(userId:String, firstName: String, lastName:String, phone: String, imgUrl: String, completionHandeler: @escaping (User?, String?) -> ()){
        
        let param = ["firstName" : firstName,
                     "lastName": lastName,
                     "phone": phone,
                     "picture": imgUrl]
        AF.request("\(API.baseURL)/user/\(userId)", method: .put, parameters: param, encoder: JSONParameterEncoder.default, headers: API.headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                let jsonData = JSON(response.value!)
                let decoder = JSONDecoder()
                do {
                    let user = try decoder.decode(User.self, from: jsonData.rawData())
                    completionHandeler(user,nil)
                } catch let error{
                    print(error)
                }
            case .failure(let error):
                let jsonData = JSON(response.data)
            }
        }
    }
    
}
