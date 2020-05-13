//
//  Category.swift
//  Artable
//
//  Created by pop on 5/12/20.
//  Copyright © 2020 pop. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Category{
    var name:String
    var id:String
    var imageUrl:String
    var isActive:Bool = true
    var timeStamp:Timestamp
    
    init(data:[String:Any]) {
        self.name = data["name"] as? String ?? ""
         self.id = data["id"] as? String ?? ""
        self.imageUrl = data["imageUrl"] as? String ?? ""
        self.isActive = data["isActive"] as? Bool ?? false
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
    }
}
