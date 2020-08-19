//
//  User.swift
//  Artable
//
//  Created by pop on 5/16/20.
//  Copyright © 2020 pop. All rights reserved.
//

import Foundation

struct User{
    var userName:String
    var id:String
    var email:String
    var stripId:String
    
    init(id:String="",email:String="",userName:String="",stripId:String=""){
        self.id = id
        self.email = email
        self.userName = userName
        self.stripId = stripId
    }
    
    init(data:[String:Any]){
        self.id = data["id"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.userName = data["userName"] as? String ?? ""
        self.stripId = data["stripId"] as? String ?? ""
    }
    
    static func modalTodata(user:User)->[String:Any]{
        let data:[String:Any] = [
            "id" : user.id,
            "email" : user.email,
            "userName" : user.userName,
            "stripId" : user.stripId
        ]
        return data
    }
}
