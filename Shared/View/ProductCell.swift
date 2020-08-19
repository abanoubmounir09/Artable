//
//  ProductCell.swift
//  Artable
//
//  Created by pop on 5/12/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import Kingfisher

protocol productCellDelegate:class {
    func productFavorited(product:Product)
}


class ProductCell: UITableViewCell {
    //OUTLETs
    @IBOutlet weak var favoriteBTN: UIButton!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var roductPrice: UILabel!
    @IBOutlet weak var productImg: rondedImageView!
    //variables
    weak var delegate:productCellDelegate?
    var product:Product!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(product:Product,delegate:productCellDelegate){
        self.product = product
        self.delegate = delegate
        productTitle.text = product.name
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber){
            roductPrice.text = price
        }
        if let url = URL(string: product.imageUrl){
            let option:KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            productImg.kf.indicatorType = .activity
            productImg.kf.setImage(with: url,options:option)
        }
        
        if UserService.favorites.contains(product){
            favoriteBTN.setImage(UIImage(named: "full-star"), for: .normal)
        }else{
            favoriteBTN.setImage(UIImage(named: "empty-star"), for: .normal)
        }
    }
    @IBAction func addToCartBTN(_ sender: Any) {
    }
    
    @IBAction func favoriteClicked(_ sender: Any) {
        delegate?.productFavorited(product: product)
    }
}
