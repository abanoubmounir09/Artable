//
//  Extensions.swift
//  Artable
//
//  Created by pop on 5/11/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import Firebase

extension UIViewController{
    func simpleAlert(title:String,message:String){
        let alert = UIAlertController(title: title  , message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}


