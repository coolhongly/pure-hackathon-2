//
//  APIController.swift
//  HelloWorld
//
//  Created by hongli.yin on 4/28/16.
//  Copyright © 2016 hongli.yin. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
    func didReceiveSimpleResults(results: Bool)
    func didReceiveListResults(results: NSArray)
}

class APIController {
    var delegate: APIControllerProtocol?
    
    static let server_url: String = "localhost"
    static let server_port: String = "8000"
    
    static let create_url: String = "https://\(server_url):\(server_port)/api/create"
    static let delete_url: String = "https://\(server_url):\(server_port)/api/delete"
    static let claim_url: String = "https://\(server_url):\(server_port)/api/claim"
    static let unClaim_url: String = "https://\(server_url):\(server_port)/api/unClaim"
    static let list_url: String = "https://\(server_url):\(server_port)/api/list"

    
    func postSimple(url: String, json: NSDictionary) {
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted)
            
            let request = createPostRequest(APIController.create_url, data: data)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
                print("PROGRESS: simple completed")
                
                if (error != nil) {
                    print("CREATE ERROR: \(error!.localizedDescription)")
                    fatalError()
                }
                
                self.delegate?.didReceiveSimpleResults(true)
            }
            
            task.resume()
        } catch let error as NSError {
            print("JSON ERROR: \(error.localizedDescription)")
        }
    }
    
    func createPostRequest(url: String, data: NSData?) -> NSURLRequest {
        let url = NSURL(string: APIController.list_url)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = data
        return request
    }
    
    func createGetRequest(url: String) -> NSURLRequest {
        let url = NSURL(string: APIController.list_url)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        return request
    }
    
    // -- API ---------------------------------
    
    func create(createUserId: String,
                comment: String,
                canClaim: Bool) {
        let json: [String: AnyObject] = [
            "create_user_id": createUserId,
            "comment": comment,
            "can_claim": canClaim
        ]
        
        postSimple(APIController.create_url, json: json)
    }
    
    func delete(postId: Int,
                createUserId: String) {
        let json: [String: AnyObject] = [
            "post_id": postId,
            "create_user_id": createUserId
        ]
        
        postSimple(APIController.delete_url, json: json)
    }
    
    func claim(postId: Int,
               claimUserId: String) {
        let json: [String: AnyObject] = [
            "post_id": postId,
            "claim_user_id": claimUserId
        ]
        
        postSimple(APIController.claim_url, json: json)
    }
    
    func unClaim(postId: Int,
                 claimUserId: String) {
        let json: [String: AnyObject] = [
            "post_id": postId,
            "claim_user_id": claimUserId
        ]
        
        postSimple(APIController.unClaim_url, json: json)

    }

    func list() {
        let request = createGetRequest(APIController.list_url)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            print("PROGRESS: list completed")
            
            if (error != nil) {
                print("LIST ERROR: \(error!.localizedDescription)")
                fatalError()
            }
            
            do {
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    if let results: NSArray = jsonResult["results"] as? NSArray {
                        self.delegate?.didReceiveListResults(results)
                }
            } catch let error as NSError {
                print("JSON ERROR: \(error.localizedDescription)")
                fatalError()
            }
        }
        
        task.resume()
    }
    
}