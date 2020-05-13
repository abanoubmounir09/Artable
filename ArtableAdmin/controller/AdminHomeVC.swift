//
//  ViewController.swift
//  ArtableAdmin
//
//  Created by pop on 5/7/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit

class AdminHomeVC: HomeVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem?.isEnabled = false
        let addCategoryBtn = UIBarButtonItem(title: "Add Category", style: .plain, target: self, action: #selector(AddCAtegory))
        navigationItem.rightBarButtonItem = addCategoryBtn
    }

    @objc func AddCAtegory(){
    // segue to addvc
        performSegue(withIdentifier: Segues.ToAddEditCategory, sender: self)
    }
}

