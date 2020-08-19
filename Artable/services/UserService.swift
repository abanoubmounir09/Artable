//
//  UserService.swift
//  Artable
//
//  Created by pop on 5/16/20.
//  Copyright © 2020 pop. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

let UserService = _UserService()

final class _UserService{
    //VAriables
    var user = User()
    var favorites = [Product]()
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var userListner:ListenerRegistration? = nil
    var favoriteListner:ListenerRegistration? = nil
    
    var isGuest:Bool{
        guard let authuser = auth.currentUser else{
            return true
        }
        if authuser.isAnonymous == true{
            return true
        }else{
            return false
        }
    }
    
    func getCurrentUser(){
        guard let authUser = auth.currentUser else{return}
        let userRef = Firestore.firestore().collection("users").document(authUser.uid)
        userListner = userRef.addSnapshotListener({ (snap, error) in
            if let error = error{
                print(error.localizedDescription)
                return
                }
            guard let data = snap?.data()else{return}
            self.user = User.init(data: data)
            print("************ use is = \(self.user)")
        })
        
        let FavRef = userRef.collection("favorites")
        favoriteListner = FavRef.addSnapshotListener({ (snap, error) in
            if let error = error{
                 print(error.localizedDescription)
                return
            }
            snap?.documents.forEach({ (query) in
                let favorite = Product.init(data: query.data())
                self.favorites.append(favorite)
            })
        })
    }
    
    
    func favoritedSelected(product:Product){
        let favsRef = Firestore.firestore().collection("users").document(user.id).collection("favorites")
        if favorites.contains(product){
            //remove
            favorites.removeAll{$0 == product}
            favsRef.document(product.id).delete()
        }else{
            favorites.append(product)
            let data = Product.modalToData(product: product)
            favsRef.document(product.id).setData(data)
        }
    }
    
    func logOutUser(){
        userListner?.remove()
        userListner = nil
        favoriteListner?.remove()
        favoriteListner = nil
        user = User()
        favorites.removeAll()
    }
}
