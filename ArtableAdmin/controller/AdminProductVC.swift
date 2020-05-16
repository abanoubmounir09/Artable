//
//  AdminProductVC.swift
//  ArtableAdmin
//
//  Created by pop on 5/14/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit

class AdminProductVC: ProductVCV {

    var selectedProduct:Product?
    override func viewDidLoad() {
        super.viewDidLoad()
        let editCategoryBtn = UIBarButtonItem(title: "Edit Category", style: .plain, target: self, action: #selector(editCategory))
        let editProductBtn = UIBarButtonItem(title: "+Product", style: .plain, target: self, action: #selector(addProduct))
        navigationItem.setRightBarButtonItems([editCategoryBtn,editProductBtn], animated: false)
        
    }
    
    @objc func editCategory(){
        performSegue(withIdentifier: Segues.AdminToEditCategory, sender: self)
    }
    
    @objc func addProduct(){
        performSegue(withIdentifier: Segues.AdminToAddEditProduct, sender: self)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //edit product
        selectedProduct = products[indexPath.row]
        performSegue(withIdentifier: "ToAddEditProduct", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAddEditProduct"{
            if let vc = segue.destination as? AddEditProductsVC{
                vc.productToEdit = selectedProduct
                vc.selectedCategory = category
            }
        }else if segue.identifier == Segues.AdminToEditCategory{
            if let vc = segue.destination as? AddEditCategoryVC{
                vc.category = category
            }
        }
    }
    
}//ensd class
