//
//  Firebase+Utils.swift
//  Artable
//
//  Created by pop on 5/11/20.
//  Copyright © 2020 pop. All rights reserved.
//

import Firebase

extension Auth{
    func handlFireAuthError(error:Error,vc:UIViewController){
        if let errorCode = AuthErrorCode(rawValue: error._code){
            let alert = UIAlertController(title: "error", message: errorCode.errorMessage, preferredStyle: .alert)
            let okAction =   UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            vc.present(alert, animated: true, completion: nil)
        }
    }
}

extension AuthErrorCode{
    var errorMessage :String{
        switch self {
        case .emailAlreadyInUse:
            return "email is already in use"
        case .invalidEmail:
            return "email is invalid"
        case .wrongPassword:
            return "wrong pasword"
        default :
            return "error"
        }
    }
}
