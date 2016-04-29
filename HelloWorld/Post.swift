//
//  Parser.swift
//  HelloWorld
//
//  Created by hongli.yin on 4/29/16.
//  Copyright © 2016 hongli.yin. All rights reserved.
//

import Foundation
import UIKit

let myUserId: String = UIDevice.currentDevice().identifierForVendor!.UUIDString

class Post {
    
    enum Type {
        case Invalid
        case Simple
        case ToDelete
        case ToClaim
        case ToUnClaim
        case Claimed
    }
    
    var postId: Int
    var createUserId: String
    var comment: String
    var canClaim: Bool
    var isClaimed: Bool
    var claimUserId: String
    var createDate: Int64
    
    var type: Type
    
    init() {
        postId = 0
        createUserId = String()
        comment = String()
        canClaim = false
        isClaimed = false
        claimUserId = String()
        createDate = 0
        type = .Invalid
    }
    
    init(rowData: NSDictionary) {
        // cast values in the dictionary to string
        let postId = rowData["post_id"] as! String
        let createUserId = rowData["create_user_id"] as! String
        let comment = rowData["comment"] as! String
        let canClaim = rowData["can_claim"] as! String
        let isClaimed = rowData["is_claimed"] as! String
        let claimUserId = rowData["claim_user_id"] as! String
        let createDate = rowData["create_date"] as! String
        
        self.postId = Int(postId)!
        self.createUserId = createUserId
        self.comment = comment
        self.canClaim = canClaim.lowercaseString == "true"
        self.isClaimed = isClaimed.lowercaseString == "true"
        self.claimUserId = claimUserId
        self.createDate = Int64(createDate)!
        self.type = .Invalid
        
        interpret()
    }
    
    func interpret() {
        if !canClaim {
            type = .Simple
        } else {
            if myUserId == createUserId {
                type = .ToDelete
            } else {
                if !isClaimed {
                    type = .ToClaim
                } else {
                    if myUserId == claimUserId {
                        type = .ToUnClaim
                    } else {
                        type = .Claimed
                    }
                }
            }
        }
    }
    
}
