//
//  RegisterVC.swift
//  Artable
//
//  Created by pop on 5/7/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {
    
    //MARK: - OUTlets
    @IBOutlet weak var usernameTXT: UITextField!
    @IBOutlet weak var emailTXT: UITextField!
    @IBOutlet weak var passwordTXT: UITextField!
    @IBOutlet weak var confirmpaswordTXT: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cofirmpasscheckImg: UIImageView!
    @IBOutlet weak var passckeckImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTXT.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmpaswordTXT.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(_ textfield:UITextField){
        guard let passtxt = passwordTXT.text else{return}
        //if we begin statrt writing in confirm Pass
        if textfield == confirmpaswordTXT{
            passckeckImg.isHidden = false
            cofirmpasscheckImg.isHidden = false
        }else{
            if passtxt.isEmpty{
                passckeckImg.isHidden = true
                cofirmpasscheckImg.isHidden = true
                confirmpaswordTXT.text = ""
            }
        }

        if passwordTXT.text == confirmpaswordTXT.text{
            passckeckImg.image = UIImage(named: "ok")
            cofirmpasscheckImg.image = UIImage(named: "ok")
        }else{
            passckeckImg.image = UIImage(named: "cancel")
             cofirmpasscheckImg.image = UIImage(named: "cancel")
        }
    }
    //MARK: - REGISTER USER
    @IBAction func registerClicked(_ sender: UIButton) {
        guard let username = usernameTXT.text,!username.isEmpty,
            let email = emailTXT.text,!email.isEmpty,
        let password = passwordTXT.text, !password.isEmpty,
        let confirmpassword = confirmpaswordTXT.text,!confirmpassword.isEmpty else{
            simpleAlert(title: "error", message: "fill all field")
            return
        }
        if confirmpassword != password{
            simpleAlert(title: "error", message: "password dont match")
        }else{
            activityIndicator.startAnimating()
            guard let authUser = Auth.auth().currentUser else{return }
            //MARK: - Linked anonymou User with email and pass
            let Creditial = EmailAuthProvider.credential(withEmail: email, password: password)
            authUser.link(with: Creditial) { (result, error) in
                if let error = error{
                    Auth.auth().handlFireAuthError(error: error, vc: self)
                    self.activityIndicator.stopAnimating()
                    return
                }else{
                    self.activityIndicator.stopAnimating()
                    self.dismiss(animated: true, completion: nil)
                }
            }
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

extension RegisterVC:UITextFieldDelegate{
    
}
