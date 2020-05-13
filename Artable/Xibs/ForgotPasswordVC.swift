//
//  ForgotPasswordVC.swift
//  Artable
//
//  Created by pop on 5/11/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailTXT: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func CancelBTN(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func ResetBTN(_ sender: Any) {
        guard let email = emailTXT.text,!email.isEmpty else{simpleAlert(title: "Error", message: "Wrong Email")
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error{
                Auth.auth().handlFireAuthError(error: error, vc: self)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }

}//end Class
