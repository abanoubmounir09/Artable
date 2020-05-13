//
//  ProductDetailVC.swift
//  Artable
//
//  Created by pop on 5/13/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import Kingfisher

class ProductDetailVC: UIViewController {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var bgView: UIVisualEffectView!
    
    var product:Product!
    override func viewDidLoad() {
        super.viewDidLoad()
        configurProduct()
    }
    
    func configurProduct(){
        productTitle.text = product.name
      //  productPrice.text = String(str) product.price
        productDescription.text = product.productDescription
        if let url = URL(string: product.imageUrl){
            productImage.kf.setImage(with: url)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber){
             productPrice.text = price
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismisproduct))
        tap.numberOfTapsRequired = 1
        bgView.addGestureRecognizer(tap)
    }
    
    @objc func dismisproduct(){
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addCartBtn(_ sender: Any) {
        //
         dismiss(animated: true, completion: nil)
    }
    
    @IBAction func keepShopingBtn(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
}
