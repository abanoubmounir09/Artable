//
//  AddEditProductsVC.swift
//  ArtableAdmin
//
//  Created by pop on 5/14/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class AddEditProductsVC: UIViewController {
    //IBOUTLETS
    @IBOutlet weak var productNameTxt: UITextField!
    @IBOutlet weak var productImg: rondedImageView!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var productPriceTxt: UITextField!
    @IBOutlet weak var btnAdd: RoundedButton!
    @IBOutlet weak var activityIndc: UIActivityIndicatorView!
    //Variables
    var name = ""
    var price = 0.0
    var prductDescription = ""
    
    var selectedCategory:Category?
    var productToEdit : Product?
    override func viewDidLoad() {
        super.viewDidLoad()
        productImg.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped))
        tap.numberOfTapsRequired = 1
        productImg.addGestureRecognizer(tap)
        if let product = productToEdit{
            btnAdd.setTitle("save Changes", for: .normal)
            productNameTxt.text = product.name
            productDescription.text = product.productDescription
            productPriceTxt.text = String(product.price)
            if let url = URL(string:product.imageUrl){
                productImg.kf.setImage(with: url)
            }
        }
    }
    @objc func imgTapped(){
        LaunchImagePiker()
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
        UploadImageThenDcument()
    }
    
    func UploadImageThenDcument(){
        guard let image = productImg.image,
            let name = productNameTxt.text,!name.isEmpty ,
        let description = productDescription.text, !description.isEmpty,
        let priceString = productPriceTxt.text ,!priceString.isEmpty,
        let price = Double(priceString)else{
                simpleAlert(title: "Error", message: "category must have name and image")
                activityIndc.stopAnimating()
                return
        }
        self.name = name
        self.price = price
        self.prductDescription = description
        //1- turn image to data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else{return}
        //step2 create storage image reference
        let imageRef = Storage.storage().reference().child("productImages/\(name).jpg")
        //3- set metadata
        let meataData = StorageMetadata()
        meataData.contentType = "image/jpg"
        //4 - upload the data
        imageRef.putData(imageData, metadata: meataData) { (metadata, error) in
            if let error = error {
                self.simpleAlert(title: "Error", message:error.localizedDescription)
                self.activityIndc.stopAnimating()
                return
            }
            //5- download image to get url
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    self.simpleAlert(title: "Error", message:error.localizedDescription)
                    self.activityIndc.stopAnimating()
                    return
                }
                guard let url = url else{return}
                self.activityIndc.stopAnimating()
                self.UploadDocument(with: url.absoluteString)
            })
        }
    }// end func
    
    func UploadDocument(with url : String){
        let docRef : DocumentReference!
        var product = Product(name: self.name, id: "", category: (selectedCategory?.id)!, price: price, productDescription: prductDescription, imageUrl: url, stok: 0)
        if let productToEdit = productToEdit{
            //edit
            docRef = Firestore.firestore().collection("products").document(productToEdit.id)
            product.id = productToEdit.id
        }else{
            // new product
            docRef = Firestore.firestore().collection("products").document()
            product.id = docRef.documentID
        }

        let data = Product.modalToData(product: product)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.simpleAlert(title: "Error", message:error.localizedDescription)
                self.activityIndc.stopAnimating()
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }//end
    
}//end

extension AddEditProductsVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func LaunchImagePiker(){
        let imagepicker = UIImagePickerController()
        imagepicker.delegate = self
        present(imagepicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else{return}
        productImg.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
