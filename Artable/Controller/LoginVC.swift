//
//  LoginVC.swift
//  Artable
//
//  Created by pop on 5/7/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var emailTXT: UITextField!
    @IBOutlet weak var passwordTXT: UITextField!
    @IBOutlet weak var activityIndecator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
    }
    

    @IBAction func ForgetPassClicked(_ sender: UIButton) {
        let vc = ForgotPasswordVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func loginBTN(_ sender: Any) {
        activityIndecator.startAnimating()
        print("login")
        guard let email = emailTXT.text, !email.isEmpty,
            let password = passwordTXT.text, !password.isEmpty else{
                simpleAlert(title: "error" , message: "fill all field")
                return
                
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
           // guard let strongSelf = self else { return }
            if let error = error{
                Auth.auth().handlFireAuthError(error: error, vc: self!)
                self!.activityIndecator.stopAnimating()
            }else{
                print("login succes")
                self!.activityIndecator.stopAnimating()
                self?.dismiss(animated: true, completion: nil)
            }
        }
        
    }

    @IBAction func GuestClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
