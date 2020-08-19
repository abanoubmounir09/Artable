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
    //MARK:- IOUTLETs
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var LoginOutBtn: UIBarButtonItem!
    @IBOutlet weak var actvityindicator: UIActivityIndicatorView!
    //MARK:- Variables
    var categories = [Category]()
    var selectedCategory : Category?
    var db:Firestore!
    var listener:ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setUpCollection()
        setUpIntialAnonymous()
       setNavigationBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
  
    
    func setNavigationBar(){
        guard  let font = UIFont(name: "futura", size: 26) else{return}
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:font]
    }
    
    func setUpCollection(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: identefiers.CategoryCell, bundle: nil), forCellWithReuseIdentifier: identefiers.CategoryCell)
    }
    
    func setUpIntialAnonymous(){
        if  Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    Auth.auth().handlFireAuthError(error: error, vc: self)
                }
            }
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
         setCategoryListner()
        if let user = Auth.auth().currentUser ,!user.isAnonymous{
            LoginOutBtn.title = "logOut"
            //print("*/*/*/*/*/*/*/*/*/\(user.uid)")
            if UserService.userListner == nil{
                UserService.getCurrentUser()
            }
        }else{
            LoginOutBtn.title = "logIn"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
        categories.removeAll()
        collectionView.reloadData()
        
    }
    
    
    func setCategoryListner(){
        listener = db.collection("categories").addSnapshotListener({ (snap, error) in
            if let error = error{
                self.simpleAlert(title: "error", message: error.localizedDescription)
                return
            }
            snap?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let category = Category.init(data: data)
                switch change.type{
                case .added:
                    self.onDecomentAdded(change: change, category: category)
                case .modified:
                    self.onDecomentUpdated(change: change, category: category)
                case .removed:
                    self.onDecomentRemoved(change: change)
                }
            })
        })
    }
    @IBAction func favoriteBtn(_ sender: Any) {
        performSegue(withIdentifier: Segues.ToFavorites, sender: self)
    }
    
    //MARK: -LOGOUT
    @IBAction func LoginOutBtn(_ sender: UIBarButtonItem) {
        guard let user = Auth.auth().currentUser else{return}
        if user.isAnonymous{
            presentLoginVC()
        }else{
            do{
             try Auth.auth().signOut()
                UserService.logOutUser()
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

extension HomeVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func onDecomentAdded(change:DocumentChange,category:Category){
        let newIndex = Int(change.newIndex)
        categories.insert(category, at: newIndex)
        collectionView.insertItems(at: [IndexPath(item: newIndex, section: 0)])
    }
    func onDecomentUpdated(change:DocumentChange,category:Category){
        if change.oldIndex == change.newIndex{
            let index = Int(change.oldIndex)
            categories[index] = category
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }else{
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            categories.remove(at: oldIndex)
            categories.insert(category, at: newIndex)
            collectionView.moveItem(at:IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
        }
    }
    func onDecomentRemoved(change:DocumentChange){
        let oldIndex = Int(change.oldIndex)
        categories.remove(at: oldIndex)
        collectionView.deleteItems(at: [IndexPath(item: oldIndex, section: 0)])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell{
            cell.configureCell(category: categories[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let cellWidth = (width - 30) / 2
        let cellHight = cellWidth * 1.5
        return CGSize(width: cellWidth, height: cellHight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        performSegue(withIdentifier: Segues.ToProductVC, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToProductVC{
            if let destination = segue.destination as? ProductVCV{
                destination.category = selectedCategory
            }else if segue.identifier == Segues.ToFavorites{
                if let destination = segue.destination as? ProductVCV{
                    destination.category = selectedCategory
                    destination.showFavorite = true
                }
            }
        }
    }
}


//    func fetchDocument(){
//        let docRef = db.collection("categories").document("XNiHm7rQsWNrJU3kJvre")
//          docRef.getDocument { (snapshot, error) in
//            guard let data = snapshot?.data() else{return}
//            let newcategory = Category.init(data: data)
//            self.categories.append(newcategory)
//            self.collectionView.reloadData()
//        }
//    }

//    func fetchCollection(){
//        let colRef = db.collection("categories")
//        listener = colRef.addSnapshotListener { (snap, error) in
//            self.categories.removeAll()
//            guard let documents = snap?.documents else{return}
//            for doc in documents {
//                let data = doc.data()
//                let newcategory = Category.init(data: data)
//                self.categories.append(newcategory)
//        }
//           self.collectionView.reloadData()
//        }
//    }
