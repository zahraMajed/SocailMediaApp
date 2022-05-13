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
    static func getAllPosts(page: Int, tag:String?, completionHandeler: @escaping ([Post], Int) -> () ){
        var url = API.baseURL + "/post"
        if var tag = tag {
            tag = tag.trimmingCharacters(in: .whitespaces)
            url = "\(API.baseURL)/tag/\(tag)/post"
        }
        let param = ["page" : "\(page)",
                     "limit": "5"]
        
        AF.request(url, parameters: param, encoder: URLEncodedFormParameterEncoder.default, headers: API.headers).responseJSON { response in
            let jsonData = JSON(response.value)
            let data = jsonData["data"]
            let total = jsonData["total"].intValue
            let decoder = JSONDecoder()
            do {
                let postsArray = try decoder.decode([Post].self, from: data.rawData())
                completionHandeler(postsArray, total)
            } catch let error{
                print(error)
            }
        }
    }
    
    // MARK: ADD NEW POST
    static func addNewPst(userID: String, text: String, imgUrl: String, completionHandeler: @escaping () -> ()){
        
        //if body parameter use: JSONParameterEncoder
        let param = ["owner": userID,
                     "text": text,
                     "image": imgUrl]
        //post request
        AF.request("\(API.baseURL)/post/create", method: .post, parameters: param, encoder: JSONParameterEncoder.default, headers: API.headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                completionHandeler()
            case .failure(let error):
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
