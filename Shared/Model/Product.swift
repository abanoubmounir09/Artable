//
//  Product.swift
//  Artable
//
//  Created by pop on 5/12/20.
//  Copyright © 2020 pop. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Product {
    var name:String
    var id:String
    var category:String
    var price:Double
    var productDescription:String
    var imageUrl:String
    var timeStamp:Timestamp
    var stok:Int
    
    init(data:[String:Any]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.category = data["category"] as? String ?? ""
        self.price = data["price"] as? Double ?? 7.0
        self.productDescription = data["productDescription"] as? String ?? ""
        self.imageUrl = data["imageUrl"] as? String ?? ""
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
        self.stok = data["stok"] as? Int ?? 0
    }
}
