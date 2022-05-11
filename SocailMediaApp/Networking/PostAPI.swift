//
//  PostAPI.swift
//  SocailMediaApp
//
//  Created by Zahra Majed on 09/10/1443 AH.
//

import Foundation
import Alamofire
import SwiftyJSON

class PostAPI {
    
    static func getAllPosts(completionHandeler: @escaping ([Post]) -> () ){
        AF.request("\(API.baseURL)/post", headers: API.headers).responseJSON { response in
            let jsonData = JSON(response.value!)
            let data = jsonData["data"]
            //Now convert json to struct (valid format in swift)
            let decoder = JSONDecoder()
            do {
                let postsArray = try decoder.decode([Post].self, from: data.rawData())
                completionHandeler(postsArray)
            } catch let error{
                print(error)
            }
        }
    }
    
    static func getPostComments(postID: String, completionHandeler: @escaping ([Comments]) -> () ){
        AF.request("\(API.baseURL)/post/\(postID)/comment", headers: API.headers).responseJSON { response in
            let jsonData = JSON(response.value!)
            let data = jsonData["data"]
            let decoder = JSONDecoder()
            do {
                let commentsArray = try decoder.decode([Comments].self, from: data.rawData())
                completionHandeler(commentsArray)
            } catch let error{
                print(error)
            }
        }
    }
    
    static func addNewCommentToPst(postId: String, userID: String, msg: String, completionHandeler: @escaping () -> ()){
        
        //if body parameter use: JSONParameterEncoder
        let param = ["post" : postId,
                     "message": msg,
                     "owner": userID]
        //post request
        AF.request("\(API.baseURL)/comment/create", method: .post, parameters: param, encoder: JSONParameterEncoder.default, headers: API.headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                completionHandeler()
            case .failure(let error):
                print(error)
                
            }
        }
    }

    
}
