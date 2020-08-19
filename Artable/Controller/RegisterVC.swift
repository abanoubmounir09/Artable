//
//  RegisterVC.swift
//  Artable
//
//  Created by pop on 5/7/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import FirebaseFirestore
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
    // variables
    var userRef : DocumentReference!
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
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let error = error{
                    Auth.auth().handlFireAuthError(error: error, vc: self)
                    self.activityIndicator.stopAnimating()
                    return
                }
                guard let firUser = result?.user else{return}
                let artUser = User(id: firUser.uid, email: email, userName: username, stripId: "")
                self.createFirestoreUser(with: artUser)
                self.activityIndicator.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            }
           
            
            
            
//             guard let authUser = Auth.auth().currentUser else{return }
//            //MARK: - Linked anonymou User with email and pass
//            let Creditial = EmailAuthProvider.credential(withEmail: email, password: password)
//            authUser.link(with: Creditial) { (result, error) in
//                if let error = error{
//                    Auth.auth().handlFireAuthError(error: error, vc: self)
//                    self.activityIndicator.stopAnimating()
//                    return
//                }else{
//                    guard let firuser = result?.user else{return}
//                    let artUser = User(id: firuser.uid, email: email, userName: username, stripId: "")
//                    //create fireStore User
//                    self.createFirestoreUser(with: artUser)
//                    self.activityIndicator.stopAnimating()
//                    self.dismiss(animated: true, completion: nil)
//                }
//            }
        }
    }//endbtn
    
    func createFirestoreUser(with user:User){
        // step 1 create referencnce
        userRef = Firestore.firestore().collection("users").document(user.id)
        // ste2 create user
        let data = User.modalTodata(user: user)
        //step 3 upload to firestore
        userRef.setData(data) { (error) in
           if let error = error{
                Auth.auth().handlFireAuthError(error: error, vc: self)
                self.activityIndicator.stopAnimating()
                self.dismiss(animated: true, completion: nil)
                return
        }
    }
}
    
}//end class
