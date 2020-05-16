//
//  AddEditCategoryVC.swift
//  ArtableAdmin
//
//  Created by pop on 5/13/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditCategoryVC: UIViewController {

    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var categoryImage: rondedImageView!
    @IBOutlet weak var activityIndecator: UIActivityIndicatorView!
    var category:Category?
    
    @IBOutlet weak var addBTN: RoundedButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        categoryImage.isUserInteractionEnabled = true
        tap.numberOfTapsRequired = 1
        categoryImage.addGestureRecognizer(tap)
        if let categorytoEdit = category{
            addBTN.setTitle("save changes", for: .normal)
            categoryName.text = categorytoEdit.name
            if let url = URL(string: categorytoEdit.imageUrl){
                categoryImage.kf.setImage(with: url)
            }
        }
    }
    @objc func imgTapped(){
        LaunchImagePiker()
    }
    @IBAction func addCaetgoryBTN(_ sender: Any) {
        //add
        activityIndecator.startAnimating()
        UploadImageThenDcument()
    }
    
    func UploadImageThenDcument(){
        guard let image = categoryImage.image,
            let name = categoryName.text,!name.isEmpty else{
                simpleAlert(title: "Error", message: "category must have name and image")
                activityIndecator.stopAnimating()
                return
        }
        //1- turn image to data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else{return}
        //step2 create storage image reference
        let imageRef = Storage.storage().reference().child("categoryImages/\(name).jpg")
        //3- set metadata
        let meataData = StorageMetadata()
        meataData.contentType = "image/jpg"
        //4 - upload the data
        imageRef.putData(imageData, metadata: meataData) { (metadata, error) in
            if let error = error {
                 self.simpleAlert(title: "Error", message:error.localizedDescription)
                self.activityIndecator.stopAnimating()
                return
            }
            //5- download image to get url
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    self.simpleAlert(title: "Error", message:error.localizedDescription)
                    self.activityIndecator.stopAnimating()
                    return
                }
                guard let url = url else{return}
                self.activityIndecator.stopAnimating()
                print(url)
                self.UploadDocument(with: url.absoluteString)
            })
        }
    }// end func
    
    func UploadDocument(with url : String){
        let docRef : DocumentReference!
        var newcategory = Category(name: categoryName.text!, id: "", imageUrl: url,  timeStamp: Timestamp())
        if let categoryToEdit = category{
            //edit
            docRef = Firestore.firestore().collection("categories").document(categoryToEdit.id)
            newcategory.id = categoryToEdit.id
        }else{
            // new category
            docRef = Firestore.firestore().collection("categories").document()
            newcategory.id = docRef.documentID
        }
        
        let data = Category.convertModel(category: newcategory)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.simpleAlert(title: "Error", message:error.localizedDescription)
                self.activityIndecator.stopAnimating()
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
}//end Class

extension AddEditCategoryVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func LaunchImagePiker(){
        let imagepicker = UIImagePickerController()
        imagepicker.delegate = self
        present(imagepicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else{return}
        categoryImage.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
