//
//  ViewController.swift
//  Artable
//
//  Created by pop on 5/7/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {

    @IBOutlet weak var LoginOutBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        //:MARK: - CKECH if User is loggin
        if  Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    Auth.auth().handlFireAuthError(error: error, vc: self)
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if let user = Auth.auth().currentUser ,!user.isAnonymous{
            LoginOutBtn.title = "logOut"
        }else{
            LoginOutBtn.title = "logIn"
        }
    }
    //MARK: -LOGOUT
    @IBAction func LoginOutBtn(_ sender: UIBarButtonItem) {
        guard let user = Auth.auth().currentUser else{return}
        if user.isAnonymous{
            presentLoginVC()
        }else{
            do{
             try Auth.auth().signOut()
                Auth.auth().signInAnonymously { (result, error) in
                    if let error = error{
                          Auth.auth().handlFireAuthError(error: error, vc: self)
                    }
                }
             presentLoginVC()
            }catch{
                 Auth.auth().handlFireAuthError(error: error, vc: self)
            }
        }
    }
    //MARK: - present LoginVC method
    fileprivate func presentLoginVC() {
        let storyboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Loginvc")
        present(controller, animated: true, completion: nil)
    }
        

}
