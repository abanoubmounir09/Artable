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

        // Do any additional setup after loading the view.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
