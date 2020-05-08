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
     //
        if let user = Auth.auth().currentUser {
            print(user.uid, user.displayName)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if let _ = Auth.auth().currentUser {
            LoginOutBtn.title = "logout"
        }else{
            LoginOutBtn.title = "logIn"
        }
    }
    
    @IBAction func LoginOutBtn(_ sender: UIBarButtonItem) {
        if let _ = Auth.auth().currentUser {
            // we are Login in
            do{
                try Auth.auth().signOut()
                presentLoginVC()
            }catch{print("error in login out")}
        }else{
            presentLoginVC()
        }
    }
    fileprivate func presentLoginVC() {
        let storyboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Loginvc")
        present(controller, animated: true, completion: nil)
    }
        

}
