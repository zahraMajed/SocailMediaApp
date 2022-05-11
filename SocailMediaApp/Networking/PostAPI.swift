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
    
    // MARK: GET ALL POSTS
    static func getAllPosts(tag:String?, completionHandeler: @escaping ([Post]) -> () ){
        var url = API.baseURL + "/post"
        if var tag = tag {
            tag = tag.trimmingCharacters(in: .whitespaces)
            url = "\(API.baseURL)/tag/\(tag)/post"
        }
        AF.request(url, headers: API.headers).responseJSON { response in
            let jsonData = JSON(response.value)
            let data = jsonData["data"]
            let decoder = JSONDecoder()
            do {
                let postsArray = try decoder.decode([Post].self, from: data.rawData())
                completionHandeler(postsArray)
            } catch let error{
                print(error)
            }
        }
    }
    
    // MARK: GET POST'S COMMENT
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
    
    // MARK: ADD NEW COMMENT
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
    
    // MARK: GET ALL TAGS
    static func getAllTags(completionHandeler: @escaping ([String]) -> () ){
        AF.request("\(API.baseURL)/tag", headers: API.headers).responseJSON { response in
            let jsonData = JSON(response.value!)
            let data = jsonData["data"]
            let decoder = JSONDecoder()
            do {
                let tagsArray = try decoder.decode([String].self, from: data.rawData())
                completionHandeler(tagsArray)
            } catch let error{
                print(error)
            }
        }
    }

    
}
