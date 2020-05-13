//
//  CategoryCell.swift
//  Artable
//
//  Created by pop on 5/12/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCell: UICollectionViewCell {
    
    //OUTLETS
    @IBOutlet weak var CategoryImage: UIImageView!
    @IBOutlet weak var CategoryLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        CategoryImage.layer.cornerRadius = 5
    }
    
    func configureCell(category:Category){
        self.CategoryLbl.text = category.name
        if let url = URL(string: category.imageUrl){
            CategoryImage.kf.indicatorType = .activity
            CategoryImage.kf.setImage(with: url)
        }
    }
}
